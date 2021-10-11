unit UFrmDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPMan, RunProcess, ExProgressBar;

type
  TFrmDemo = class(TForm)
    BtnExec: TButton;
    PB: TProgressBar;
    EdtCommand: TEdit;
    Label1: TLabel;
    gbExec: TGroupBox;
    gbWait: TGroupBox;
    Label2: TLabel;
    procedure BtnExecClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ProcBegin(Sender: TObject);
    procedure ProcEnd(Sender: TObject);
  end;

var
  FrmDemo: TFrmDemo;

implementation

{$R *.dfm}

procedure TFrmDemo.FormCreate(Sender: TObject);
begin
  //System.ReportMemoryLeaksOnShutdown := True;
  //gbWait.Left := gbExec.Left;
  //ClientWidth := gbExec.Width;
  Top := 0;
  Left := (Screen.Width - Width) div 2; 
end;

procedure TFrmDemo.BtnExecClick(Sender: TObject);
begin
  with TRunProcess.Create('notepad.exe') do
  begin
    AutoFree := True;
    OnProcessBegin := ProcBegin;
    OnProcessEnd := ProcEnd;
    Execute;
  end;
end;

procedure TFrmDemo.ProcBegin(Sender: TObject);
begin
  PB.Marquee := True;
  BtnExec.Enabled:=false;
  EdtCommand.Enabled:=false;
  //gbExec.Hide;
  //gbWait.Show;
end;

procedure TFrmDemo.ProcEnd(Sender: TObject);
begin
  //gbWait.Hide;
  //gbExec.Show;
  BtnExec.Enabled:=true;
  EdtCommand.Enabled:=true;
  PB.Marquee := False;
end;

end.
