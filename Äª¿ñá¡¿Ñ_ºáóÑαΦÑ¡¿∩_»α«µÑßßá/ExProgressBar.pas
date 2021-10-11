unit ExProgressBar;

interface

uses
  Windows, Messages, Classes, SysUtils, Controls, ComCtrls;
type
  TProgressBar = class(ComCtrls.TProgressBar)
  private
    { Délai de mise à jour de l'état de la progressbar }
    FDelay: Integer;
    { Indique si la fenetre est configurée pour l'aancement automatique
    Mise à True automatiquement si Marquee est mis à True }
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
    { Propriétés }
    property MarqueeDelay: Integer read FDelay write SetDelay;
    property Marquee: Boolean read FMarquee write SetMarquee;
    property CanMarquee: Boolean read FCanMarquee write SetCanMarquee;
  end;

implementation

const
  { Style de progressbar - Valide uniquement avec Windows XP et nécéssite
  un TXPManifest ou autre artifice du genre }
  PBS_MARQUEE = $08;

  { Message windows permettant de définir l'état "Marquee" pour les progressbar
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
      {>> Force la feêtre à être compatible }
      SetCanMarquee(True);

      {>> Active le marquee }
      SendMessage(Handle, PBM_SETMARQUEE, 1, FDelay);
    end
    else
      {>> Désactive le marquee }
      SendMessage(Handle, PBM_SETMARQUEE, 0, 0);
  end;
end;

procedure TProgressBar.SetCanMarquee(Value: Boolean);
begin
  if Value <> FCanMarquee then
  begin
    {>> mémorise }
    FCanMarquee := Value;

    {>> Et recrée la fenetre: lance un appel à CreateParams() qui va inclure
    ou non le style PBS_MARQUEE }
    RecreateWnd;
  end;
end;

end.
