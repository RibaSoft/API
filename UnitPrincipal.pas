//OBS Executar o Lazarus como administrador para evitar erros.
//Libs: fphttpclient, opensslsockets, fpjson
//dlls: libssl-1_1.dll e libcrypto-1_1.dll

unit UnitPrincipal; {$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, fphttpclient, opensslsockets, fpjson, DBGrids,
  BufDataset, DB;

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
    FCodigo: string;
    FMensagem: string;
    FStatus: integer;
    GroupBoxs: array[1 .. 6] of TGroupBox;
    Memo1: TMemo;
    btn: TButton;
    DBGridDados: TDBGrid;
    BufDados: TBufDataset;
    DataSouceDados: TDataSource;
  published
    procedure Login(Sender: TObject);
    procedure InsereDados(Sender: TObject);
    procedure PegaDados(Sender: TObject);
    property Status: integer read FStatus write FStatus;
    property Codigo: string read FCodigo write FCodigo;
    property Mensagem: string read FMensagem write FMensagem;
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
  FCodigo := EmptyStr;
  FMensagem := EmptyStr;

  ComboBoxRotas.Items.Add('https://ribasoft.com.br/api_testes/login.php');
  ComboBoxRotas.Items.Add('https://ribasoft.com.br/api_testes/insere_dados.php');
  ComboBoxRotas.Items.Add('https://ribasoft.com.br/api_testes/pega_dados.php');
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

  if (Memo1 <> nil) then
    FreeAndNil(Memo1);

  if (DBGridDados <> nil) then
    FreeAndNil(DBGridDados);

  if (BufDados <> nil) then
    FreeAndNil(BufDados);

  if (DataSouceDados <> nil) then
    FreeAndNil(DataSouceDados);
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
      GroupBoxs[I] := TGroupBox.Create(Self);
      GroupBoxs[I].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[I].Parent := Self;
      GroupBoxs[I].Left := GroupBoxRotas.Left;
      GroupBoxs[I].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[I].Caption := 'Usuário';
      GroupBoxs[I].AutoSize := True;
      GroupBoxs[I].Visible := True;

      Edits[I] := TEdit.Create(Self);
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

    1: //Insere Dados
    begin
      GroupBoxs[1] := TGroupBox.Create(Self);
      GroupBoxs[1].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[1].Parent := Self;
      GroupBoxs[1].Left := GroupBoxRotas.Left;
      GroupBoxs[1].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[1].Caption := 'Dados';
      GroupBoxs[1].AutoSize := True;

      Memo1 := TMemo.Create(Self);
      Memo1.Name := 'Memo1';
      Memo1.Parent := GroupBoxs[1];
      Memo1.Width := 300;
      Memo1.Height := 460;
      Memo1.Clear;
      Memo1.Lines.Add('Ribamar;45;1.82');
      Memo1.Lines.Add('Ana;40;1.60');
      Memo1.Lines.Add('Pedro;19;1.80');
      Memo1.Lines.Add('Davi;14;1.79');
      Memo1.Lines.Add('Elias;12;1.78');
      Memo1.Lines.Add('Benjamim;4;1');

      btn := TButton.Create(Self);
      btn.Name := 'btn1';
      btn.Parent := Self;
      btn.Top := GroupBoxs[1].Top + GroupBoxs[1].Height - btn.Height;
      btn.Left := GroupBoxs[1].Left + GroupBoxs[1].Width + 10;
      btn.Caption := 'Enviar';
      btn.OnClick := @InsereDados;
    end;

    2: //Pega Dados
    begin
      GroupBoxs[1] := TGroupBox.Create(Self);
      GroupBoxs[1].Name := 'GroupBox' + IntToStr(I);
      GroupBoxs[1].Parent := Self;
      GroupBoxs[1].Left := GroupBoxRotas.Left;
      GroupBoxs[1].Top := GroupBoxRotas.Top + 50;
      GroupBoxs[1].Caption := 'Dados';
      GroupBoxs[1].AutoSize := True;

      DBGridDados := TDBGrid.Create(Self);
      DBGridDados.Name := 'dbgrid1';
      DBGridDados.Parent := GroupBoxs[1];
      DBGridDados.Width := 600;
      DBGridDados.Height := 460;

      DBGridDados.Columns.Add.FieldName := 'DATA_HORA';
      DBGridDados.Columns.Add.FieldName := 'NOME';
      DBGridDados.Columns.Add.FieldName := 'IDADE';
      DBGridDados.Columns.Add.FieldName := 'ALTURA';

      DBGridDados.Columns[0].Title.Caption := 'Data/Hora';
      DBGridDados.Columns[0].Title.Alignment := taCenter;
      DBGridDados.Columns[0].Alignment := taCenter;
      DBGridDados.Columns[0].Width := Trunc((DBGridDados.Width - 37) * 0.25);

      DBGridDados.Columns[1].Title.Caption := 'Nome';
      DBGridDados.Columns[1].Title.Alignment := taCenter;
      DBGridDados.Columns[1].Width := Trunc((DBGridDados.Width - 37) * 0.45);

      DBGridDados.Columns[2].Title.Caption := 'Idade';
      DBGridDados.Columns[2].Title.Alignment := taCenter;
      DBGridDados.Columns[2].Alignment := taCenter;
      DBGridDados.Columns[2].Width := Trunc((DBGridDados.Width - 37) * 0.15);

      DBGridDados.Columns[3].Title.Caption := 'Altura';
      DBGridDados.Columns[3].Title.Alignment := taCenter;
      DBGridDados.Columns[3].Alignment := taCenter;
      DBGridDados.Columns[3].Width := Trunc((DBGridDados.Width - 37) * 0.15);
      DBGridDados.Columns[3].DisplayFormat := '#,##0.00';

      DataSouceDados := TDataSource.Create(Self);
      DBGridDados.DataSource := DataSouceDados;

      BufDados := TBufDataset.Create(Self){%H-};
      DataSouceDados.DataSet := BufDados;

      btn := TButton.Create(Self);
      btn.Name := 'btn1';
      btn.Parent := Self;
      btn.Top := GroupBoxs[1].Top + GroupBoxs[1].Height - btn.Height;
      btn.Left := GroupBoxs[1].Left + GroupBoxs[1].Width + 10;
      btn.Caption := 'Buscar';
      btn.OnClick := @PegaDados;
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
        Status := auxH.ResponseStatusCode;
        MessageDlg(auxRetorno.DataString, mtConfirmation, [mbOK], 0, mbYes);

        if (Status = 200) then
        begin
          try
            auxJSon := GetJSON(auxRetorno.DataString);
            Codigo := auxJSon.FindPath('codigo').AsString;
            Mensagem := auxJSon.FindPath('mensagem').AsString;

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
        end;
      finally
        FreeAndNil(auxRetorno);
      end;

    finally
      auxH.RequestBody.Free;
    end;
  finally
    FreeAndNil(auxH);
  end;
end;

//======================================================= INSERE DADOS ===============================================\\
procedure TFormPrincipal.InsereDados(Sender: TObject);
var
  auxH: TFPHTTPClient;
  auxJSonString: string;
  auxNome, auxAltura, auxIdade: string[30];
  auxCampos: TStringList;
  I: integer;
  auxRetorno: TStringStream;
  auxJSon: TJSONData;
begin
  auxJSonString := '{"familia":[';

  for I := 0 to Pred(Memo1.Lines.Count) do
  begin
    try
      auxCampos := TStringList.Create;
      auxCampos.Delimiter := ';';
      auxCampos.DelimitedText := Memo1.Lines[I];

      auxNome := auxCampos[0];
      auxIdade := auxCampos[1];
      auxAltura := auxCampos[2];

      auxJSonString += '{"nome":"' + auxNome + '","idade":"' + auxIdade + '","altura":"' + auxAltura + '"},';

    finally
      FreeAndNil(auxCampos);
    end;
  end;

  auxJSonString := Copy(auxJSonString, 1, Pred(Length(auxJSonString))) + ']}';

  try
    auxH := TFPHTTPClient.Create(Self);
    auxH.AllowRedirect := True;
    try
      auxH.RequestBody := TRawByteStringStream.Create(auxJSonString);
      try
        auxRetorno := TStringStream.Create;
        auxH.Post(ComboBoxRotas.Text, auxRetorno);
        Status := auxH.ResponseStatusCode;
        MessageDlg(auxRetorno.DataString, mtConfirmation, [mbOK], 0, mbYes);

        if (Status = 200) then
        begin
          try
            auxJSon := GetJSON(auxRetorno.DataString);
            Codigo := auxJSon.FindPath('codigo').AsString;
            Mensagem := auxJSon.FindPath('mensagem').AsString;
          finally
            FreeAndNil(auxJSon);
          end;
        end;
      finally
        FreeAndNil(auxRetorno);
      end;
    finally
      auxH.RequestBody.Free;
    end;
  finally
    FreeAndNil(auxH);
  end;
end;

//====================================================== PEGA DADOS ==================================================\\
procedure TFormPrincipal.PegaDados(Sender: TObject);
var
  auxH: TFPHTTPClient;
  auxRetorno: TStringStream;
  auxJSon: TJSONData;
  auxJSonDados: TJSONArray;
  I: Integer;
  auxDataHora, auxNome: String;
  auxIdade: Integer;
  auxAltura: Currency;
begin
  try
    auxH := TFPHTTPClient.Create(Self);
    auxH.AllowRedirect := True;

      try
        auxRetorno := TStringStream.Create;
        auxH.Get(ComboBoxRotas.Text, auxRetorno);
        Status := auxH.ResponseStatusCode;
        MessageDlg(auxRetorno.DataString, mtConfirmation, [mbOK], 0, mbYes);

        if (Status = 200) then
        begin
          try
            auxJSon := GetJSON(auxRetorno.DataString);
            Codigo := auxJSon.FindPath('codigo').AsString;
            Mensagem := auxJSon.FindPath('mensagem').AsString;

            auxJSonDados := TJSONArray(auxJSon.FindPath('retorno'));

            BufDados.Clear;
            BufDados.FieldDefs.Add('DATA_HORA',ftDateTime);
            BufDados.FieldDefs.Add('NOME',ftString, 60);
            BufDados.FieldDefs.Add('IDADE',ftInteger);
            BufDados.FieldDefs.Add('ALTURA',ftCurrency);
            BufDados.CreateDataset;

            if (Assigned(auxJSonDados)) then
            begin
              for I := 0 to Pred(auxJSonDados.Count) do
              begin
                auxDataHora := auxJSonDados.Items[I].FindPath('DATA_HORA').AsString; //2024-07-06 17:48:42
                auxNome := auxJSonDados.Items[I].FindPath('NOME').AsString;
                auxIdade := auxJSonDados.Items[I].FindPath('IDADE').AsInteger;
                auxAltura := auxJSonDados.Items[I].FindPath('ALTURA').AsFloat;

                BufDados.Append;
                BufDados.FieldByName('DATA_HORA').AsDateTime := StrToDateTime(Copy(auxDataHora,09,2) + '/' +
                  Copy(auxDataHora,06,2) + '/' + Copy(auxDataHora,01,4) + ' ' + Copy(auxDataHora,12,8));
                BufDados.FieldByName('NOME').AsString := auxNome;
                BufDados.FieldByName('IDADE').AsInteger := auxIdade;
                BufDados.FieldByName('ALTURA').AsCurrency := auxAltura;
                BufDados.Post;
              end;
            end;
          finally
            FreeAndNil(auxJSon);
          end;
        end;
      finally
        FreeAndNil(auxRetorno);
      end;
  finally
    FreeAndNil(auxH);
  end;
end;

//====================================================================================================================\\
end.
