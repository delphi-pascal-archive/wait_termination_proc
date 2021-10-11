unit ExProgressBar;

interface

uses
  Windows, Messages, Classes, SysUtils, Controls, ComCtrls;
type
  TProgressBar = class(ComCtrls.TProgressBar)
  private
    { D�lai de mise � jour de l'�tat de la progressbar }
    FDelay: Integer;
    { Indique si la fenetre est configur�e pour l'aancement automatique
    Mise � True automatiquement si Marquee est mis � True }
    FCanMarquee: Boolean;
    { Indique si la progressbar est n mode "Marquee" }
    FMarquee: Boolean;
    { Setters }
    procedure SetDelay(Value: Integer);
    procedure SetMarquee(Value: Boolean);
    procedure SetCanMarquee(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    { Propri�t�s }
    property MarqueeDelay: Integer read FDelay write SetDelay;
    property Marquee: Boolean read FMarquee write SetMarquee;
    property CanMarquee: Boolean read FCanMarquee write SetCanMarquee;
  end;

implementation

const
  { Style de progressbar - Valide uniquement avec Windows XP et n�c�ssite
  un TXPManifest ou autre artifice du genre }
  PBS_MARQUEE = $08;

  { Message windows permettant de d�finir l'�tat "Marquee" pour les progressbar
  dont le style inclut PBS_MARQUEE }
  PBM_SETMARQUEE = WM_USER + 10;

constructor TProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDelay := 100;
  FCanMarquee := False;
  FMarquee := False;
end;

procedure TProgressBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if FCanMarquee then
    Params.Style := Params.Style or PBS_MARQUEE;
end;

procedure TProgressBar.SetDelay(Value: Integer);
begin
  if (Value <> FDelay) and (Value > 0) then
  begin
    FDelay := Value;
    if FMarquee then
      {>> Change la vitesse }
      SendMessage(Handle, PBM_SETMARQUEE, 1, FDelay);
  end;
end;

procedure TProgressBar.SetMarquee(Value: Boolean);
begin
  if Value <> FMarquee then
  begin
    FMarquee := Value;
    if FMarquee then
    begin
      {>> Force la fe�tre � �tre compatible }
      SetCanMarquee(True);

      {>> Active le marquee }
      SendMessage(Handle, PBM_SETMARQUEE, 1, FDelay);
    end
    else
      {>> D�sactive le marquee }
      SendMessage(Handle, PBM_SETMARQUEE, 0, 0);
  end;
end;

procedure TProgressBar.SetCanMarquee(Value: Boolean);
begin
  if Value <> FCanMarquee then
  begin
    {>> m�morise }
    FCanMarquee := Value;

    {>> Et recr�e la fenetre: lance un appel � CreateParams() qui va inclure
    ou non le style PBS_MARQUEE }
    RecreateWnd;
  end;
end;

end.
