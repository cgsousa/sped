unit uprinc00;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Mask, ExtCtrls, ActnList, //ulayout01 ,
  uclass,
  JvExMask, JvToolEdit, JvExControls,
  JvXPCore, JvXPCheckCtrls, JvExComCtrls, JvComCtrls ,
  JvExStdCtrls, JvGroupBox, JvEdit, JvValidateEdit, JvCombobox,
  JvExExtCtrls, JvExtComponent, JvPanel, JvMemo,

  Generics.Defaults, Generics.Collections ,

  EFD00 ;

type
  TJvComboBox = class(JvCombobox.TJvComboBox)
  public
    procedure DoAddStr(const AStr: string; const ADefaultItemIndex: Integer =0);
  end;

{$REGION 'Tcademp00List'}
type
  Tcademp00List = class;
  Tcademp00 = class
  private
    Index:Integer;
  public
    Codigo:Integer;
    Nome  :string ;
    CNPJ  :string ;
    CodMun:Integer;
    UF:string ;
  end;

  Tcademp00List = class(TList<Tcademp00>)
  private
  public
    function AddNew(const Codigo: Integer): Tcademp00 ;
    function IndexOf(const Codigo: Integer): Tcademp00; overload ;
    function CLoad(StrList: TStrings): Boolean ;
  end;

{$ENDREGION}

type
  TfrmPrinc00 = class(TForm)
//  TfrmPrinc00 = class(Tfrm_layout01)
    PageControl1: TJvPageControl;
    tabFiscal: TTabSheet;
    tabContr: TTabSheet;
    tabConfig: TTabSheet;
    btnClose: TButton;
    GroupBox1: TGroupBox;
    edtDtIni: TJvDateEdit;
    edtDtFin: TJvDateEdit;
    Label1: TLabel;
    chkBlocoD: TJvXPCheckbox;
    chkBlocoH: TJvXPCheckbox;
    chkBloco1: TJvXPCheckbox;
    rgFinalidade: TRadioGroup;
    rgPerfil: TRadioGroup;
    rgIndAtv: TRadioGroup;
    btnExecute: TButton;
    GroupBox2: TGroupBox;
    edtDir: TJvDirectoryEdit;
    GroupBox3: TGroupBox;
    cbxEmpresa: TJvComboBox;
    Label2: TLabel;
    tabProcess: TTabSheet;
    gbxVerLay: TGroupBox;
    cbxCOD_VER: TJvComboBox;
    gbxTIPO_ESCRIT: TRadioGroup;
    GroupBox4: TGroupBox;
    cbxIND_SIT_ESP: TJvComboBox;
    gbxNumRecibo: TGroupBox;
    edtNUM_REC_ANTERIOR: TJvValidateEdit;
    GroupBox5: TGroupBox;
    cbxIND_NAT_PJ: TJvComboBox;
    GroupBox6: TGroupBox;
    cbxIND_ATIV: TJvComboBox;
    GroupBox7: TGroupBox;
    cbxIND_APRO_CRED: TJvComboBox;
    Label4: TLabel;
    Label6: TLabel;
    cbxIND_REG_CUM: TJvComboBox;
    Panel1: TPanel;
    Label3: TLabel;
    cbxCOD_INC_TRIB: TJvComboBox;
    JvPanel1: TJvPanel;
    Label5: TLabel;
    cbxCOD_TIPO_CONT: TJvComboBox;
    mmOnLog: TJvMemo;
    edtECF_FAB: TJvValidateEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure cbxIND_SIT_ESPSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtDirButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    process_cod: Boolean;
    process_msg: string ;
    create_dir: string ;
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnLOG(Sender: TObject; const StrLog: string);
    procedure DoRUN;
    procedure DoRunEFDContr() ;

  protected
    cademp00: Tcademp00 ;
    cademp00List :Tcademp00List;
    EFD: TLoadEFD;
    function ValidPeriodo(var F: TFilterEFD): Boolean ;

  public
    { Public declarations }

    CRec       : TCThreadProcRec;
    CStop      : Boolean;
    procedure DoStart();
    procedure DoStop;
    procedure DoReset() ;

  end;

var
  frmPrinc00: TfrmPrinc00;


implementation

uses DateUtils, StrUtils, DB ,
  uunidac, ulog ,
  ufisbloco_0,
  uctrbloco_0;

{$R *.dfm}

var
  CLog: TSWLog = nil;

type
  TRunEFD = record
    codemp: Integer;
    dt_ini,dt_fin: TDateTime ;
    OnLOG: TOnSWLogChange;
  end;

procedure AddLog(message: string); overload;
begin
  if Assigned(CLog) then
  begin
    CLog.AddLog('uprinc00.' + message);
  end;
end;

procedure AddLog(const cformat: string; const Args: array of const); overload;
begin
  AddLog(Format(cformat, args));
end;


procedure TfrmPrinc00.btnCloseClick(Sender: TObject);
begin
  Self.Close ;
end;

procedure TfrmPrinc00.btnExecuteClick(Sender: TObject);
var
  msg: string;
var
  F: TFilterEFD;
begin

  Msg :=Format('Deseja gerar a Escrituração em "%s" ?', [edtDir.Text]);
  if MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    Exit;
  end;

  if not ValidPeriodo(F) then
  begin
    Exit ;
  end;

  if not Assigned(CRec.CExec) then
  begin
    DoStart;
  end
  else
  begin
    DoStop;
  end;

  Sleep(1000);
end;

procedure TfrmPrinc00.cbxIND_SIT_ESPSelect(Sender: TObject);
begin
  gbxNumRecibo.Enabled :=TComboBox(Sender).ItemIndex = 1;
end;

procedure TfrmPrinc00.DoReset;
begin
  PageControl1.ActivePageIndex :=0 ;
  edtDtIni.Date :=StartOfTheMonth(uunidac.ConnDatabase.GetSysDatetime -30) ;
  edtDtFin.Date :=EndOfTheMonth(edtDtIni.Date) ;

  edtDir.Directory :=ExcludeTrailingPathDelimiter( ExtractFilePath(Application.ExeName) );

  if not cademp00List.CLoad(cbxEmpresa.Items) then
  begin
    cbxEmpresa.Items.Add('NENHUMA ENTIDADE / PESSOA FISICA ENCONTRADA!');
    btnExecute.Enabled :=False ;
  end;
  cbxEmpresa.ItemIndex :=0;

  //EFD-Contribuiçoes
  cbxCOD_VER.DoAddStr('Cód.003-Versão 102');
  cbxCOD_VER.Enabled :=False;
  cbxIND_SIT_ESP.DoAddStr(
    '"0 - Abertura","1 - Cisão","2 - Fusão","3 - Incorporação","4 – Encerramento"'
    );

  cbxIND_NAT_PJ.DoAddStr(
    '"00 – Pessoa jurídica em geral",'+
    '"01 – Sociedade cooperativa",'+
    '"02 – Entidade sujeita ao PIS/Pasep exclusivamente com base na Folha de Salários"'
    );

  cbxIND_ATIV.DoAddStr(
    '"0 – Industrial ou equiparado a industrial",'+
    '"1 – Prestador de serviços",'+
    '"2 - Atividade de comércio",'+
    '"3 – Pessoas jurídicas referidas nos §§ 6º, 8º e 9º do art. 3º da Lei nº 9.718, de 1998",'+
    '"4 – Atividade imobiliária",'+
    '"9 – Outros"', 2
    );

  cbxCOD_INC_TRIB.DoAddStr(
    '"1 – Escrituração de operações com incidência exclusivamente no regime não-cumulativo",'+
    '"2 – Escrituração de operações com incidência exclusivamente no regime cumulativo",'+
    '"3 – Escrituração de operações com incidência nos regimes não-cumulativo e cumulativo"'
    );

  cbxIND_APRO_CRED.DoAddStr(
    '"1 – Método de Apropriação Direta",'+
    '"2 – Método de Rateio Proporcional (Receita Bruta)"'
    );

  cbxCOD_TIPO_CONT.DoAddStr(
    '"1 – Apuração da Contribuição Exclusivamente a Alíquota Básica",'+
    '"2 – Apuração da Contribuição a Alíquotas Específicas (Diferenciadas e/ou por Unidade de Medida de Produto)"'
    );

  cbxIND_REG_CUM.DoAddStr(
    '"1 – Regime de Caixa – Escrituração consolidada (Registro F500)",'+
    '"2 – Regime de Competência - Escrituração consolidada (Registro F550)",'+
    '"9 – Regime de Competência - Escrituração detalhada, com base nos registros dos Blocos “A”, “C”, “D” e “F”"'
    );

end;

procedure TfrmPrinc00.DoRUN;
var
  F: TFilterEFD ;
  FIS: TSpedFiscal ;
var
  OnLogChange: TOnSWLogChange;
begin

  EFD00.CLog.OnSWLogChange :=Self.OnLOG;

  F.CodEmp :=1;
  F.DtaIni :=edtDtIni.Date ;
  F.DtaFin :=edtDtFin.Date ;
  F.DocTyp :=[docEnt];
  F.IndInv :=chkBlocoH.Checked ;
  F.ecf_fab:=edtECF_FAB.Text;

  FIS :=TSpedFiscal.Create;
  try
    EFD :=FIS ;
    AddLog('Criou objeto SPED (EFD-ICMS/IPI)');
    FIS.CodFinaly :=cfOrig;
    FIS.Perfil :=perfil_A ;
    FIS.Path :=create_dir;

    process_cod :=FIS.Execute(F);
    if process_cod then
      process_msg :='Processo concluído.'#13'EFD ICMS/IPI gerada com sucesso.'
    else
      process_msg :='Processo cancelado!'#13'Falha na geração EFD ICMS/IPI! Verifique o LOG!';

  finally
    FIS.Free ;
  end;

end;

procedure TfrmPrinc00.DoRunEFDContr;
var
  F: TFilterEFD ;
  CNT: TSpedContrib ;
begin

  F.CodEmp :=1;
  F.DtaIni :=edtDtIni.Date ;
  F.DtaFin :=edtDtFin.Date ;
  F.DocTyp :=[docEnt] ;

  CNT :=TSpedContrib.Create;
  try
    EFD :=CNT ;
    CNT.IndTipEsc :=TIndTypEsc(gbxTIPO_ESCRIT.ItemIndex);
    CNT.IndSitEsp :=TIndSitEsp(cbxIND_SIT_ESP.ItemIndex);
    CNT.IndNatPJ  :=TIndNatPJ(cbxIND_NAT_PJ.ItemIndex);
    CNT.Path :=create_dir ;

    process_cod :=CNT.Execute(F);
    if process_cod then
    begin
      process_msg :='Processo concluído.'#13'EFD-Contribuições gerada com sucesso.'
    end
    else begin
      process_msg :='Processo cancelado!'#13'Falha na geração da EFD-Contribuições! Verifique o LOG';
    end;

  finally
    CNT.Free ;
  end;

end;

procedure TfrmPrinc00.DoStart;
begin

  CRec.OnIni := Self.OnINI;
  CRec.OnEnd := Self.OnEND;
  if PageControl1.ActivePageIndex = 0 then
  begin
    CRec.CProc := Self.DoRUN ;
  end
  else begin
    CRec.CProc := Self.DoRunEFDContr;
  end;
  CRec.CExec := TCThreadProc.Create(CRec);

  btnExecute.Caption := 'Parar';
  btnExecute.Enabled :=False;

end;

procedure TfrmPrinc00.DoStop;
begin
  CStop := True;
  if Assigned(EFD) then
  begin
    EFD.DoStop;
  end;
end;

procedure TfrmPrinc00.edtDirButtonClick(Sender: TObject);
begin
//
end;

procedure TfrmPrinc00.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Deseja sair do Gerador ?', mtConfirmation, [mbYes,mbNo], 0) = mrNo then
  begin
    CanClose :=False ;
  end;
end;

procedure TfrmPrinc00.FormCreate(Sender: TObject);
begin
  CRec.CExec:=nil;
  cademp00  :=Tcademp00.Create ;
  cademp00List:=Tcademp00List.Create ;

end;

procedure TfrmPrinc00.FormDestroy(Sender: TObject);
begin
  cademp00.Destroy ;
  cademp00List.Destroy ;

end;

procedure TfrmPrinc00.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    btnCloseClick(Sender);
  end;
end;

procedure TfrmPrinc00.FormShow(Sender: TObject);
begin
  DoReset() ;
end;

procedure TfrmPrinc00.OnEND(Sender: TObject);
begin
  AddLog('Finalizou serviço (%s:run:OnEND)', [Self.ClassName]);
  if process_cod then
    MessageDlg(process_msg, mtInformation, [mbOK], 0)
  else
    MessageDlg(process_msg, mtWarning, [mbOK], 0);

  btnExecute.Caption := 'Executar';
  btnExecute.Enabled :=True;
  btnClose.Enabled :=True;
  CRec.CExec := nil;
end;

procedure TfrmPrinc00.OnINI(Sender: TObject);
begin
  btnExecute.Enabled :=True;
  btnClose.Enabled :=False;
  PageControl1.ActivePage :=tabProcess ;
  mmOnLog.Clear ;

  create_dir :=Format('%s\%.8s-%s\%d',[ edtDir.Directory,
                                        cademp00.CNPJ,
                                        cademp00.Nome,
                                        YearOf(edtDtFin.Date)]);

  CLog.AddLog('Iniciou serviço (%s:run:OnINI)', [Self.ClassName]);
  EFD00.CLog :=uprinc00.CLog ;

end;

procedure TfrmPrinc00.OnLOG(Sender: TObject; const StrLog: string);
begin
//  mmOnLog.Lines.Insert(0, StrLog);
  mmOnLog.Lines.Add(StrLog);
end;

procedure TfrmPrinc00.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0,1: btnExecute.Enabled :=True;
  else
    btnExecute.Enabled :=False;
  end;
end;


function TfrmPrinc00.ValidPeriodo(var F: TFilterEFD): Boolean;
begin
  Result :=False ;
  F.DtaIni :=0;
  F.DtaFin :=0;
  if YearOf(edtDtIni.Date) < 2005 then
  begin
    MessageDlg('Data inicial inferior ao SPED !', mtWarning, [mbOK], 0) ;
    edtDtIni.SetFocus ;
  end
  else if YearOf(edtDtFin.Date) < 2005 then
  begin
    MessageDlg('Data final inferior ao SPED !', mtWarning, [mbOK], 0) ;
    edtDtFin.SetFocus ;
  end
  else begin
    if edtDtIni.Date > edtDtFin.Date then
    begin
      MessageDlg('Data inicial maior que data final !', mtWarning, [mbOK], 0) ;
      edtDtIni.SetFocus ;
    end
    else begin
      F.DtaIni :=edtDtIni.Date ;
      F.DtaFin :=edtDtFin.Date ;
      Result :=True ;
    end;
  end;

end;


{ TJvComboBox }

procedure TJvComboBox.DoAddStr(const AStr: string;
  const ADefaultItemIndex: Integer);
begin
  if Pos('","', AStr) = 0 then
    Self.AddItem(AStr, nil)
  else begin
    Self.Items.CommaText :=AStr;
  end;
  Self.ItemIndex :=ADefaultItemIndex ;
end;

{$REGION 'Tcademp00List'}
  { Tcademp00List }

  function Tcademp00List.AddNew(const Codigo: Integer): Tcademp00 ;
  begin
    Result :=Self.IndexOf(Codigo) ;
    if Result = nil then
    begin
      Result :=Tcademp00.Create ;
      Result.Index :=Self.Count ;
      Result.Codigo :=Codigo ;
    end;
  end;

  function Tcademp00List.CLoad(StrList: TStrings): Boolean;
  var
    Q: TUniQuery ;
  var
    femp_codigo,
    femp_codmun: TField ;

  var
    E: Tcademp00 ;

  begin

    Q :=TUniQuery.NewQuery();
    try

      Q.SQL.Add('select                                 ');
      Q.SQL.Add('  emp.id_filial as emp_codigo,         ');
      Q.SQL.Add('  emp.nome  as emp_nome   ,            ');
      Q.SQL.Add('  emp.cnpj  as emp_cnpj   ,            ');
      Q.SQL.Add('  emp.ie  as emp_ie    ,               ');
      Q.SQL.Add('  emp.cep as emp_cep   ,               ');
      Q.SQL.Add('  emp.tipo_logradouro as emp_logr,     ');
      Q.SQL.Add('  emp.logradouro    as emp_endere,     ');
      Q.SQL.Add('  emp.numero    as emp_numero,         ');
      Q.SQL.Add('  emp.bairro  as emp_bairro,           ');
      Q.SQL.Add('  emp.tel    as emp_fone  ,            ');
      Q.SQL.Add('  emp.codigo_municipio as emp_codmun,  ');
      Q.SQL.Add('  emp.uf  as emp_uf                    ');
      Q.SQL.Add('from filial emp                        ');
      Q.SQL.Add('where emp.cnpj is not null             ');
      Q.Open ;

      Result :=not Q.IsEmpty ;
      femp_codigo :=Q.FieldOf('emp_codigo') ;
      femp_codmun :=Q.FieldOf('emp_codmun') ;

      while not Q.Eof do
      begin
        E :=Self.AddNew(femp_codigo.AsInteger) ;
        E.Nome   :=Q.FieldOf('emp_nome').AsString ;
        E.CNPJ   :=Q.FieldOf('emp_cnpj').AsString ;
        E.CodMun :=2111300;
        if(not femp_codmun.IsNull)and(femp_codmun.AsInteger > 0) then
        begin
          E.CodMun :=femp_codmun.AsInteger ;
        end ;
        E.UF :=Q.FieldOf('emp_uf').AsString ;

        if Assigned(StrList) then
        begin
          StrList.Clear ;
          StrList.Add(Format('%d-%s',[E.Codigo,E.Nome]));
        end;

        Q.Next ;
      end;

    finally
      FreeAndNil(Q);
    end;

  end;

  function Tcademp00List.IndexOf(const Codigo: Integer): Tcademp00;
  begin
    Result :=nil ;
    for Result in Self do
    begin
      if Result.Codigo = Codigo then
      begin
        Break ;
      end ;
    end;
    if Assigned(Result)and(Result.Codigo <> Codigo) then
    begin
      Result :=nil ;
    end ;
  end;

{$ENDREGION}

begin
  CLog :=TSWLog.Create;
  CLog.LogPath := ExtractFilePath(Application.ExeName);

end.
