//OBS Executar o Lazarus como administrador para evitar erros.
//Libs: fphttpclient, opensslsockets, fpjson
//dlls: libssl-1_1.dll e libcrypto-1_1.dll

unit UnitPrincipal; {$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, fphttpclient, opensslsockets, fpjson;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ComboBoxRotas: TComboBox;
    GroupBoxRotas: TGroupBox;
    procedure ComboBoxRotasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Edits: array[1 .. 6] of TEdit;
    FStatus: integer;
    GroupBoxs: array[1 .. 6] of TGroupBox;
    btn: TButton;
  published
    procedure Login(Sender: TObject);
    property Status: integer read FStatus write FStatus;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation {$R *.lfm}

//==================================================== FORM CREATE ===================================================\\
procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  Self.Caption := 'APIs by RibaSoft';
  Self.BorderStyle := bsSingle;
  Self.BorderIcons := [biSystemMenu, biMinimize];
  FStatus := 0;

  ComboBoxRotas.Items.Add('https://ribasoft.com.br/api_testes/login.php');
  //todo: criar rota para json array
  ComboBoxRotas.ItemIndex := 0;
  ComboBoxRotasChange(Sender);
end;

//=================================================== FORM DESTROY ===================================================\\
procedure TFormPrincipal.FormDestroy(Sender: TObject);
var
  I: byte;
begin
  for I := 1 to Length(Edits) do
    if (Edits[I] <> nil) then
      FreeAndNil(Edits[I]);

  for I := 1 to Length(GroupBoxs) do
    if (GroupBoxs[I] <> nil) then
      FreeAndNil(GroupBoxs[I]);

  if (btn <> nil) then
    FreeAndNil(btn);
end;

//=============================================== COMBO BOX ROTAS CHANGE =============================================\\
procedure TFormPrincipal.ComboBoxRotasChange(Sender: TObject);
var
  I: integer;
begin
  FormDestroy(Sender);

  case ComboBoxRotas.ItemIndex of
    0: //Login
    begin
      I := 1;
      GroupBoxs[I] := TGroupBox.Create(nil);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxRotas.Left;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[I].Caption := 'Usuário';
      GroupBoxs[I].AutoSize := True;
      GroupBoxs[I].Visible := True;

      Edits[I] := TEdit.Create(nil);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Text := 'adm';
      Edits[I].Visible := True;

      Inc(I);
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxs[Pred(I)].Left + 160;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[I].Caption := 'Senha';
      GroupBoxs[I].AutoSize := True;

      Edits[I] := TEdit.Create(Self);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Text := '1234';

      Inc(I);
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxs[Pred(I)].Left + 160;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[I].Caption := 'Texto';
      GroupBoxs[I].AutoSize := True;

      Edits[I] := TEdit.Create(Self);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Text := 'Teste de Texto';

      Inc(I);
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxRotas.Left;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 100;
      GroupBoxs[I].Caption := 'Retorno de Usuário';
      GroupBoxs[I].AutoSize := True;

      Edits[I] := TEdit.Create(Self);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Clear;

      Inc(I);
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxs[Pred(I)].Left + 160;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 100;
      GroupBoxs[I].Caption := 'Retorno de Senha';
      GroupBoxs[I].AutoSize := True;

      Edits[I] := TEdit.Create(Self);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Clear;

      Inc(I);
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxs[Pred(I)].Left + 160;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 100;
      GroupBoxs[I].Caption := 'Retorno de Texto';
      GroupBoxs[I].AutoSize := True;

      Edits[I] := TEdit.Create(Self);
      Edits[I].Name := 'Edit' + IntToStr(I);
      Edits[I].Parent := GroupBoxs[I];
      Edits[I].Width := 150;
      Edits[I].MaxLength := 60;
      Edits[I].Clear;

      btn := TButton.Create(Self);
      btn.Name := 'btn1';
      btn.Parent := Self;
      btn.Top := GroupBoxRotas.Top + 117;
      btn.Left := GroupBoxs[I].Left + 160;
      btn.Caption := 'Enviar';
      btn.OnClick := @Login;
    end;
  end;
end;

//====================================================== LOGIN =======================================================\\
procedure TFormPrincipal.Login(Sender: TObject);
var
  auxH: TFPHTTPClient;
  auxRetorno: TStringStream;
  auxJSon: TJSONData;
  auxJSonDados: TJSONData;
begin
  try
    auxH := TFPHTTPClient.Create(Self);
    auxH.AllowRedirect := True;
    auxH.UserName := Trim(Edits[1].Text);
    auxH.Password := Trim(Edits[2].Text);
    try
      auxH.RequestBody := TRawByteStringStream.Create('{"teste":"' + Trim(Edits[3].Text) + '"}');
      try
        auxRetorno := TStringStream.Create;
        auxH.Post(ComboBoxRotas.Text, auxRetorno);
        MessageDlg(auxRetorno.DataString, mtConfirmation, [mbOK], 0, mbYes);
        try
          auxJSon := GetJSON(auxRetorno.DataString);
          auxJSonDados := auxJSon.FindPath('retorno');

          if (Assigned(auxJSonDados)) then
          begin
            Edits[4].Text := auxJSonDados.FindPath('usuario').AsString;
            Edits[5].Text := auxJSonDados.FindPath('senha').AsString;
            Edits[6].Text := auxJSonDados.FindPath('teste').AsString;
          end;
        finally
          FreeAndNil(auxJSon);
        end;
      finally
        FreeAndNil(auxRetorno);
      end;
      Status := auxH.ResponseStatusCode;
    finally
      auxH.RequestBody.Free;
    end;
  finally
    FreeAndNil(auxH);
  end;
end;

//====================================================================================================================\\
end.
