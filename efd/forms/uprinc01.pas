unit uprinc01;

interface

{$REGION 'uses'}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Mask,

  Generics.Defaults, Generics.Collections ,

  uclass, ulayout01,

  AdvGlowButton, AdvPanel, AdvPageControl, AdvGroupBox, AdvCombo,
  AdvStyleIF, AdvSmoothMessageDialog, AdvSmoothPanel, AdvOfficeButtons ,

  JvExControls, JvNavigationPane, JvExStdCtrls, JvEdit, JvValidateEdit,
  JvExMask, JvToolEdit, JvXPCore,
  JvXPCheckCtrls, JvMemo, JvExExtCtrls, JvExtComponent, JvPanel,

  EFDCommon, EFD00,

  ExeInfo, VirtualTrees, ImgList, JvImageList, AdvAppStyler,
  DB, JvComponentBase, JvBalloonHint, ActnList, AdvEdit,
  AdvEdBtn, JvListBox, JvComboListBox, FolderDialog, JvBaseDlg,
  JvDialogs, slstbox, Menus, System.Actions, System.ImageList ;

{$ENDREGION}

type
  TCustomComboHlp = class helper for TCustomCombo
  public
    procedure Add(const AStr: string; const AItemIndex: Integer =0);
  end;

type

  TFolderDialog = class(FolderDialog.TFolderDialog)
  public
    class function NewFolderDialog(const ACaption, ATitle: string; out ADirectory: string): Boolean;
  end;

  TJvOpenDialogTypDOC = (dtdEFD, dtdNFe, dtdNFeEnt);
  TJvOpenDialog = class(JvDialogs.TJvOpenDialog)
  public
    class function NewOpenDialog(out AFiles: string;
      const ATypDOC: TJvOpenDialogTypDOC): Boolean ;
    class function ShowSelect(): TStrings;
  end;

  TtypEFD = (efdICMSIPI,efdContrib) ;
  TCProc = class(TCThreadProcess)
  private
    m_TypEFD: TtypEFD ;
    procedure RunICMSIPI() ;
    procedure RunContrib() ;
  protected
    m_CadEmp: Tcademp00 ;
    m_CadCtb: Tcadcontab00;
    m_Filter: TFilterEFD;
    procedure RunProc; override;
  public
    constructor Create(const aTypEFD: TtypEFD;
      aCadEmp: Tcademp00; aCadCtb: Tcadcontab00; const aFilter: TFilterEFD);
  end;


{$REGION 'Tfrm_princ00'}
type
  Tfrm_princ00 = class(Tfrm_layout01)
    gbx_perido: TAdvGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtDtIni: TJvDateEdit;
    edtDtFin: TJvDateEdit;
    pag_control1: TAdvPageControl;
    tab_fiscal: TAdvTabSheet;
    tab_contr: TAdvTabSheet;
    tab_config: TAdvTabSheet;
    tab_process: TAdvTabSheet;
    chkBlocoD: TJvXPCheckbox;
    chkBlocoH: TJvXPCheckbox;
    chkBloco1: TJvXPCheckbox;
    rg_Perfil: TAdvOfficeRadioGroup;
    rg_IndAtv: TAdvOfficeRadioGroup;
    gbxTIPO_ESCRIT: TRadioGroup;
    GroupBox4: TAdvGroupBox;
    cbxIND_SIT_ESP: TAdvComboBox;
    gbxNumRecibo: TAdvGroupBox;
    edtNUM_REC_ANTERIOR: TJvValidateEdit;
    GroupBox5: TAdvGroupBox;
    cbxIND_NAT_PJ: TAdvComboBox;
    GroupBox6: TAdvGroupBox;
    cbxIND_ATIV: TAdvComboBox;
    GroupBox7: TAdvGroupBox;
    cbxIND_APRO_CRED: TAdvComboBox;
    cbxIND_REG_CUM: TAdvComboBox;
    gbx_LocalEFD: TAdvGroupBox;
    edtDir: TJvDirectoryEdit;
    mmOnLog: TJvMemo;
    btn_exec: TAdvGlowButton;
    pag_control2: TAdvPageControl;
    tab_empresa: TAdvTabSheet;
    tab_contab: TAdvTabSheet;
    cbx_typdta: TAdvComboBox;
    vst_Contab: TVirtualStringTree;
    cbxEmp: TAdvComboBox;
    btn_cntnew: TAdvGlowButton;
    btn_cntedt: TAdvGlowButton;
    chkNoRegC400: TJvXPCheckbox;
    cbxCOD_INC_TRIB: TAdvComboBox;
    cbxCOD_TIPO_CONT: TAdvComboBox;
    rg_Final: TAdvOfficeRadioGroup;
    cbxCOD_VER: TAdvComboBox;
    edtECF_FAB: TAdvEdit;
    btn_LocalSai: TAdvGlowButton;
    btn_clear: TAdvGlowButton;
    pag_Saidas: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    lbx_saidas: TJvListBox;
    AdvTabSheet3: TAdvTabSheet;
    tab_Nfe: TAdvTabSheet;
    pnl_NfeEntrada: TAdvPanel;
    pnl_NfeSaida: TAdvPanel;
    AdvPanelStyler1: TAdvPanelStyler;
    lbx_NFeEnt: TJvListBox;
    lbx_NFe: TJvListBox;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    act_NfeIns: TAction;
    act_NfeClear: TAction;
    mnu_Inserir1: TMenuItem;
    mnu_Limpar1: TMenuItem;
    procedure btn_closeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vst_ContabGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure btn_cntnewClick(Sender: TObject);
    procedure btn_cntedtClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure vst_ContabChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure pag_control1Change(Sender: TObject);
    procedure edt_localEntDialogClose(Sender: TObject; NewDirectory: string;
      OK: Boolean);
    procedure btn_LocalSaiClick(Sender: TObject);
    procedure btn_execClick(Sender: TObject);
    procedure btn_clearClick(Sender: TObject);
    procedure act_NfeInsExecute(Sender: TObject);
    procedure act_NfeClearExecute(Sender: TObject);
    procedure lbx_NFeEntEnter(Sender: TObject);
  private
    { Private declarations }
    process_cod: Boolean;
    process_msg: string ;
    create_dir: string ;
//    process_tab: string ;
    procedure OnINI(Sender: TObject);
    procedure OnEND(Sender: TObject);
    procedure OnLOG(Sender: TObject; const StrLog: string);

    procedure DoRunEFDICMSIPI() ;
    procedure DoRunEFDContrib() ;

  private
    { tarefa melhorada }
    m_MyProc: TCProc ;
    procedure OnSTR(const aStr: string);
  protected
    cademp00List: Tcademp00List;
//    cadcontab00List: Tcadcontab00List;
    function ValidPeriodo(var F: TFilterEFD): Boolean ;
    procedure DoLoadContab() ;
  public
    { Public declarations }
    CRec       : TCThreadProcRec;
    CStop      : Boolean;
    procedure DoStart();
    procedure DoStop;
    procedure DoResetForm(); override ;
  end;

{$ENDREGION}

var
  frm_princ00: Tfrm_princ00;

implementation

uses DateUtils, StrUtils,
  uunidac, ulog,
  uefd_fiscal, ufisbloco_0,
  uefd_contrib, uctrbloco_0,
  EFDUtils,
  ucadcontab00;

{$R *.dfm}


{$REGION 'Tfrm_princ00'}
procedure Tfrm_princ00.act_NfeClearExecute(Sender: TObject);
begin
    //lbx_NFeEnt
    //if TMenuItem(Sender).Tag = 1 then
    if Self.Tag = 0 then
    begin
      lbx_NFeEnt.Clear;
    end
    //lbx_NFeSai
    else begin
      lbx_NFe.Clear;
    end;
end;

procedure Tfrm_princ00.act_NfeInsExecute(Sender: TObject);
var
  dir, fls: string;
  lbx: TJvListBox ;
begin

    //lbx_NFeEnt
    //if TMenuItem(Sender).Tag = 1 then
    if Self.Tag = 0 then
    begin
      if TJvOpenDialog.NewOpenDialog(fls, dtdNFeEnt) then
      begin

          if lbx_NFeEnt.Items.Count >= 1 then
            lbx_NFeEnt.Items.CommaText :=lbx_NFeEnt.Items.CommaText +','+fls
          else
            lbx_NFeEnt.Items.CommaText :=fls
            ;
      end;
    end
    //lbx_NFeSai
    else begin
      if TJvOpenDialog.NewOpenDialog(fls, dtdNFe) then
      begin

          if lbx_NFe.Items.Count >= 1 then
            lbx_NFe.Items.CommaText :=lbx_NFe.Items.CommaText +','+fls
          else
            lbx_NFe.Items.CommaText :=fls
            ;
      end;
    end;

end;

procedure Tfrm_princ00.btn_clearClick(Sender: TObject);
var
  lbx: TJvListBox ;
begin
  if pag_Saidas.ActivePageIndex = 0 then
    lbx_saidas.Clear
  else begin
    if TJvOpenDialogTypDOC(pag_Saidas.ActivePageIndex) = dtdNFe then
      lbx :=lbx_NFe
    else
      lbx :=lbx_NFeEnt ;
    lbx.Clear;
  end;
end;

procedure Tfrm_princ00.btn_closeClick(Sender: TObject);
begin
  Self.Close ;
end;

procedure Tfrm_princ00.btn_cntnewClick(Sender: TObject);
begin
  if Tfrm_cadcontab00.NewAndShowModal(nil) then
  begin
    DoLoadContab ;
  end;
end;

procedure Tfrm_princ00.btn_execClick(Sender: TObject);
var
  msg: string;
begin

  if Assigned(m_MyProc) then
  begin
    doStop ;
  end ;
  //
  // start manual
  doStart ;


  { DESCONTINUADO
  if(btn_exec.Tag = 1)and MsgDlg('Advertência','Deseja parar o processo de geração da EFD?', [mbYes,mbNo], tsOffice2003Olive) then
  begin
    DoStop();
    Exit ;
  end

  else
  begin

    if not ValidPeriodo(F) then
    begin
      Exit ;
    end;

    //if not MsgDlg('Confirmação', Format('Verifique o código da versão do leiaute! Deseja gerar a Escrituração em "%s" ?', [edtDir.Text]), [mbYes,mbNo]) then
    if not MsgDlg('Confirmação', 'Verifique o código da versão do leiaute!'#13'Deseja gerar a Escrituração ?', [mbYes,mbNo]) then
    begin
      Exit;
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
  end;}
end;

procedure Tfrm_princ00.btn_LocalSaiClick(Sender: TObject);
var
  dir, fls: string  ;
  lbx: TJvListBox ;
begin
//  if TFolderDialog.NewFolderDialog('','', dir) then
//  begin
//    btn_LocalSai.Caption :=dir ;
//    lbx_saidas.Directory :=Dir ;
//    lbx_saidas.ItemIndex :=0;
//    ActiveControl :=lbx_saidas ;
//  end;
  if TJvOpenDialog.NewOpenDialog(fls, TJvOpenDialogTypDOC(pag_Saidas.ActivePageIndex)) then
  begin
//    if Pos('","', fls) > 0 then
//      lbx_saidas.Items.CommaText :=fls
//    else
    if TJvOpenDialogTypDOC(pag_Saidas.ActivePageIndex) = dtdEFD then
    begin
      if lbx_saidas.Items.Count >= 1 then
        lbx_saidas.Items.CommaText :=lbx_saidas.Items.CommaText +','+fls
      else
        lbx_saidas.Items.CommaText :=fls
        ;
    end
    else begin
      if TJvOpenDialogTypDOC(pag_Saidas.ActivePageIndex) = dtdNFe then
        lbx :=lbx_NFe
      else
        lbx :=lbx_NFeEnt ;
      if lbx.Items.Count >= 1 then
        lbx.Items.CommaText :=lbx.Items.CommaText +','+fls
      else
        lbx.Items.CommaText :=fls
        ;
    end;
  end;

end;

procedure Tfrm_princ00.btn_cntedtClick(Sender: TObject);
var
  P: PVirtualNode;
begin
  P :=vst_Contab.GetFirstChecked() ;
  if P <> nil then
  begin

    if Tfrm_cadcontab00.NewAndShowModal(cadcontab00List.Items[P.Index]) then
    begin
      DoLoadContab
      ;
    end;

  end;
end;

procedure Tfrm_princ00.DoLoadContab;
var
  C: Tcadcontab00;
  P: PVirtualNode;
begin
  if cadcontab00List.CLoad() then
  begin
    vst_Contab.Clear ;
    for C in cadcontab00List do
    begin
      P :=vst_Contab.AddChild(nil);
      P.CheckType :=ctRadioButton ;
      if C.Index = 0 then
      begin
        P.CheckState:=csCheckedNormal ;
        C.Checkin   :=True ;
      end;
    end;
    vst_Contab.Refresh ;
  end;
end;

procedure Tfrm_princ00.DoResetForm;
begin
  inherited DoResetForm ;

  Self.DoSetHeaderCaption('ESCRITURAÇÃO FISCAL DIGITAL (EFD) - ICMS/IPI  &  CONTRIBUÍÇÕES');
  cbx_typdta.Add('"Data de Entrada","Data de Emissão"', 1);

  edtDtIni.Date :=StartOfTheMonth(uunidac.ConnDatabase.GetSysDatetime -30) ;
  edtDtFin.Date :=EndOfTheMonth(edtDtIni.Date) ;
  edtDir.Directory :=ExcludeTrailingPathDelimiter( ExtractFilePath(Application.ExeName) );
  //btn_LocalSai.Caption:=edtDir.Directory ;

  cbxCOD_VER.Add( '"COD.002=Versão 1.01",'+
                  '"COD.003=Versão 1.02",'+
                  '"COD.004=Versão 1.03",'+
                  '"COD.005=Versão 1.04",'+
                  '"COD.006=Versão 1.05",'+
                  '"COD.007=Versão 1.06",'+
                  '"COD.008=Versão 1.07",'+
                  '"COD.009=Versão 1.08",'+
                  '"COD.010=Versão 1.09",'+
                  '"COD.011=Versão 1.10",'+
                  '"COD.012=Versão 1.11",'+
                  '"COD.013=Versão 1.12",'+
                  '"COD.014=Versão 1.13"',
                   11);
{
versão=8 COD_LEI, VERSAO, DT_INI, DT_FIM
002|1.01|01012009|31122009
003|1.02|01012010|31122010
004|1.03|01012011|31122011
005|1.04|01012012|30062012
006|1.05|01072012|31122012
007|1.06|01012013|31122013
008	1.07	01012014	31122014

009	1.08	01012015	31122015
010	1.09	01012016	31122016
011	1.10	01012017	31122017
012	1.11	01012018	31122018
013	1.12	01012019	31122019
014	1.13	01012020

}

  if cademp00List.CLoad(cbxEmp.Items) then
  begin
    pag_control1.ActivePageIndex :=0 ;
    pag_control1Change(Self);
    pag_control2.ActivePageIndex :=0 ;
    btn_cntedt.Enabled :=True ;
  end
  else begin
    cbxEmp.Add('NENHUMA ENTIDADE / PESSOA FISICA ENCONTRADA!');
    pag_control1.ActivePageIndex :=2 ;
    pag_control1Change(Self);
    tab_fiscal.TabEnable :=False;
    tab_contr.TabEnable :=False ;
//    btn_exec.Enabled   :=False ;
    btn_cntedt.Enabled :=False ;
  end;
  cbxEmp.ItemIndex :=0;

  DoLoadContab;

  //EFD-Contribuiçoes
  cbxIND_SIT_ESP.Add(
    '"0 - Abertura","1 - Cisão","2 - Fusão","3 - Incorporação","4 – Encerramento"'
    );

  cbxIND_NAT_PJ.Add(
    '"00 – Pessoa jurídica em geral",'+
    '"01 – Sociedade cooperativa",'+
    '"02 – Entidade sujeita ao PIS/Pasep exclusivamente com base na Folha de Salários"'
    );

  cbxIND_ATIV.Add(
    '"0 – Industrial ou equiparado a industrial",'+
    '"1 – Prestador de serviços",'+
    '"2 - Atividade de comércio",'+
    '"3 – Pessoas jurídicas referidas nos §§ 6º, 8º e 9º do art. 3º da Lei nº 9.718, de 1998",'+
    '"4 – Atividade imobiliária",'+
    '"9 – Outros"', 2
    );

  cbxCOD_INC_TRIB.Add(
    '"1 – Escrituração de operações com incidência exclusivamente no regime não-cumulativo",'+
    '"2 – Escrituração de operações com incidência exclusivamente no regime cumulativo",'+
    '"3 – Escrituração de operações com incidência nos regimes não-cumulativo e cumulativo"'
    );

  cbxIND_APRO_CRED.Add(
    '"1 – Método de Apropriação Direta",'+
    '"2 – Método de Rateio Proporcional (Receita Bruta)"'
    );

  cbxCOD_TIPO_CONT.Add(
    '"1 – Apuração da Contribuição Exclusivamente a Alíquota Básica",'+
    '"2 – Apuração da Contribuição a Alíquotas Específicas (Diferenciadas e/ou por Unidade de Medida de Produto)"'
    );

  cbxIND_REG_CUM.Add(
    '"1 – Regime de Caixa – Escrituração consolidada (Registro F500)",'+
    '"2 – Regime de Competência - Escrituração consolidada (Registro F550)",'+
    '"9 – Regime de Competência - Escrituração detalhada, com base nos registros dos Blocos “A”, “C”, “D” e “F”"'
    );

end;

procedure Tfrm_princ00.DoRunEFDContrib;
var
  E: Tcademp00;
  C: Tcadcontab00;
var
  F: TFilterEFD ;
  EFD: TSpedContrib;
begin

  E :=cademp00List.Items[cbxEmp.ItemIndex];
  F.CodEmp :=E.Codigo;
  F.DtaIni :=edtDtIni.Date ;
  F.DtaFin :=edtDtFin.Date ;
  F.DocTyp :=[docEnt] ;
  F.DtaTyp :=TDtaTyp(cbx_typdta.ItemIndex) ;
  F.NoRegC400 :=chkNoRegC400.Checked ;
  F.EFD_Saidas:=lbx_saidas.Items ;
  F.EFD_NFe:=lbx_NFe.Items ;
  F.EFD_NFeEnt:=lbx_NFeEnt.Items ;

  AddLog('[%s].Iniciou serviço (%s:DoRunEFDContrib)',[TEFD_Contrib.EFD_NAME,Self.ClassName]);
  EFD :=TSpedContrib.Create;
  try
    EFD.Path      :=Format('%s\%.8s-%s\%d',[edtDir.Directory, E.CNPJ, E.Nome, YearOf(F.DtaFin)]);

    //Pessoa juridica
    EFD.EFD_Contrib.SetPesJur(TCodVerLay(cbxCOD_VER.ItemIndex+2), //cvl102,
                              TIndTypEsc(gbxTIPO_ESCRIT.ItemIndex),
                              TIndSitEsp(cbxIND_SIT_ESP.ItemIndex),
                              F.DtaIni, F.DtaFin,
                              E.Nome, E.CNPJ, E.UF, E.CodMun,
                              TIndNatPJ(cbxIND_NAT_PJ.ItemIndex) ,
                              taCom);

    AddLog('Entidade: Nome=%s, CNPJ=%s, Mun=%d', [E.CNPJ, E.Nome, E.CodMun]);

    if cadcontab00List.Count > 0 then
    begin
      C :=cadcontab00List.Items[0] ;
      EFD.EFD_Contrib.Bloco_0.NewReg_0100(C.ctb00_nome  ,
                                          C.ctb00_cpf ,
                                          C.ctb00_crc,
                                          C.ctb00_cnpj,
                                          C.ctb00_endere,
                                          C.ctb00_bairro,
                                          C.ctb00_cep,
                                          C.ctb00_codmun, '', '',
                                          C.ctb00_email) ;

      AddLog('Carregou contabilista(s): %d', [cadcontab00List.Count]);
    end
    else
    begin
      AddLog('Nenhum contabilista encontrado!');
    end;

    //padroniza filiais co dados da matriz
    EFD.CodEmp :=E.Codigo;
    EFD.Nome :=E.Nome ;
    EFD.CNPJ :=Tefd_util.GetNumbers(E.CNPJ) ;
    EFD.UF :=E.UF ;
    EFD.IE :=Tefd_util.GetNumbers(E.IE) ;
    EFD.CodMun :=E.CodMun;

    process_cod :=EFD.Execute(F);
    if process_cod then
    begin
      process_msg :='Processo concluído.'#13'EFD-Contribuições gerada com sucesso.'
    end
    else begin
      process_msg :='Processo cancelado!'#13'Falha na geração da EFD-Contribuições! Verifique o LOG';
    end;

  finally
    EFD.Free ;
    AddLog('[%s].Finalizou serviço (%s:DoRunEFDContrib)', [TEFD_Contrib.EFD_NAME,Self.ClassName]);
  end;

end;

procedure Tfrm_princ00.DoRunEFDICMSIPI;
var
  P: PVirtualNode;
  E: Tcademp00;
  C: Tcadcontab00;
var
  F: TFilterEFD ;
  EFD: TSpedFiscal;
begin

  E :=cademp00List.Items[cbxEmp.ItemIndex];

  F.CodEmp :=E.Codigo ;
  F.DtaIni :=edtDtIni.Date ;
  F.DtaFin :=edtDtFin.Date ;
  F.DocTyp :=[docEnt];
  F.IndInv :=chkBlocoH.Checked ;
  F.ecf_fab:=edtECF_FAB.Text;
  F.DtaTyp :=TDtaTyp(cbx_typdta.ItemIndex) ;
  F.NoRegC400 :=chkNoRegC400.Checked ;
  F.EFD_Saidas:=lbx_saidas.Items ;
  F.EFD_NFe:=lbx_NFe.Items ;
  F.EFD_NFeEnt:=lbx_NFeEnt.Items ;

  AddLog('[%s].Iniciou serviço (%s:DoRunEFDICMSIPI)', [TEFD_Fiscal.EFD_NAME,Self.ClassName]);


  EFD :=TSpedFiscal.Create;
  try
    EFD.Path:=Format('%s\%.8s-%s\%d',[edtDir.Directory, E.CNPJ, E.Nome, YearOf(F.DtaFin)]);
    EFD.EFD_Fiscal.SetEntidade(TCodVerLay(cbxCOD_VER.ItemIndex+2), // cvl106,  //varsão do leiaute
                               cfOrig,  //finalidade do arquivo
                               F.DtaIni,//data inicio do movimento
                               F.DtaFin,//data final do movimento
                               perfil_A,//perfil do contribuinte
                               atvOut , //atividade principal do contribuinte
                               E.Nome ,//nome empresarial
                               E.CNPJ ,//CNPJ
                               E.UF   ,//UF
                               E.IE   ,//insc.est
                               E.CodMun,//cod.municipio do IBGE
                               E.CEP ,
                               E.Endere,
                               E.Bairro,
                               E.Fone);

    AddLog('Entidade: Nome=%s, CNPJ=%s, Mun=%d', [E.Nome, E.CNPJ, E.CodMun]);

    if vst_Contab.RootNodeCount > 0 then
    begin
      P :=vst_Contab.GetFirstChecked() ;
      if P <> nil then
      begin
        C :=cadcontab00List.Items[P.Index] ;
        if C <> nil then
        begin
          EFD.EFD_Fiscal.SetContab( C.ctb00_nome,
                                    C.ctb00_cpf ,
                                    C.ctb00_crc ,
                                    C.ctb00_cnpj ,
                                    C.ctb00_cep ,
                                    C.ctb00_endere ,
                                    C.ctb00_bairro , '',
                                    C.ctb00_email,
                                    C.ctb00_codmun);
          AddLog('Contabilista: Nome=%s, CPF=%s, CRC=%s CNPJ=%s, Mun=%d',[
              C.ctb00_nome, C.ctb00_cpf, C.ctb00_crc, C.ctb00_cnpj, C.ctb00_codmun
              ]);
        end;
      end
      else begin
        AddLog('Nenhum contabilista marcado!');
      end;

    end
    else begin
      AddLog('Nenhum contabilista encontrado!');
    end;

    process_cod :=EFD.Execute(F,nil);
    if process_cod then
      process_msg :='Processo concluído.'#13'EFD ICMS/IPI gerada com sucesso.'
    else
      process_msg :='Processo cancelado!'#13'Falha na geração EFD ICMS/IPI! Verifique o LOG!';
    AddLog(process_msg);
  finally
    EFD.Free ;
    AddLog('[%s].Finalisou serviço (%s:DoRunEFDICMSIPI)', [TEFD_Fiscal.EFD_NAME,Self.ClassName]);
  end;

end;

procedure Tfrm_princ00.DoStart;
var
  P: PVirtualNode;
  E: Tcademp00;
  C: Tcadcontab00;
  F: TFilterEFD;
begin

  CLog :=TSWLog.Instance;
  CLog.LogPath :=ExtractFilePath(ParamStr(0));

  ulog.CLog.OnSWLogChange :=Self.OnLOG;

  {CRec.OnIni :=Self.OnINI;
  CRec.OnEnd :=Self.OnEND;
  if pag_control1.ActivePageIndex = 0 then
  begin
    CRec.CProc :=Self.DoRunEFDICMSIPI ;
  end
  else begin
    CRec.CProc :=Self.DoRunEFDContrib;
  end;
  CRec.CExec :=TCThreadProc.Create(CRec);}

  //
  // ler empresa
  E :=cademp00List.Items[cbxEmp.ItemIndex];

  //
  // preneche filtro
  F.CodEmp :=E.Codigo ;
  F.CodVer :=TCodVerLay(cbxCOD_VER.ItemIndex+2) ;
  F.DtaIni :=edtDtIni.Date ;
  F.DtaFin :=edtDtFin.Date ;
  F.DocTyp :=[docEnt];
  F.IndInv :=chkBlocoH.Checked ;
  F.ecf_fab:=edtECF_FAB.Text;
  F.DtaTyp :=TDtaTyp(cbx_typdta.ItemIndex) ;
  F.NoRegC400 :=chkNoRegC400.Checked ;
  F.EFD_Saidas:=lbx_saidas.Items ;
  F.EFD_NFe:=lbx_NFe.Items ;
  F.EFD_NFeEnt:=lbx_NFeEnt.Items ;
  F.path :=edtDir.Directory ;

  //
  // ler contabilista
  C :=nil ;
  if vst_Contab.RootNodeCount > 0 then
  begin
    P :=vst_Contab.GetFirstChecked() ;
    if P <> nil then
    begin
      C :=cadcontab00List.Items[P.Index] ;
    end;
  end ;

  //
  // prepare e start a tarefa
  if pag_control1.ActivePageIndex = 0 then
  begin
    m_MyProc :=TCProc.Create(efdICMSIPI,E,C,F) ;
  end
  else begin
    m_MyProc :=TCProc.Create(efdContrib,E,C,F) ;
  end;
  m_MyProc.OnINI :=OnINI;
  m_MyProc.OnTerminate :=OnEND;
  m_MyProc.OnStrProc :=Self.OnSTR;
  // start a tarefa
  m_MyProc.Start  ;

end;

procedure Tfrm_princ00.DoStop;
begin
  {if TLoadEFD.GetInstance <> nil then
  begin
    TLoadEFD.GetInstance.DoStop ;
    CRec.CExec :=nil ;
  end;}
  m_MyProc.Terminate;
  if not m_MyProc.Finished then
    m_MyProc.WaitFor;
  FreeAndNil(m_MyProc);
end;

procedure Tfrm_princ00.edt_localEntDialogClose(Sender: TObject;
  NewDirectory: string; OK: Boolean);
begin
  if OK then
  begin
//    flb_Entradas.Directory :=NewDirectory   ;
  end;
end;

procedure Tfrm_princ00.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not MsgDlg('Confirmação', 'Deseja sair do Gerador ?', [mbYes,mbNo]) then
  begin
    CanClose :=False ;
  end;
end;

procedure Tfrm_princ00.FormCreate(Sender: TObject);
begin
  inherited ;
  CRec.CExec:=nil;

  cademp00List :=Tcademp00List.Create ;
//  cadcontab00List :=Tcadcontab00List.Create ;
end;

procedure Tfrm_princ00.FormDestroy(Sender: TObject);
begin
  cademp00List.Destroy ;
//  cadcontab00List.Destroy ;
  ConnDatabase.Close;
end;

procedure Tfrm_princ00.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [] then
  begin
    case Key of
      VK_ESCAPE: btn_closeClick(Sender);
      VK_F2: if btn_exec.Enabled then btn_execClick(Sender)
      ;
    end;
  end;
end;

procedure Tfrm_princ00.lbx_NFeEntEnter(Sender: TObject);
begin
    if Sender = lbx_NFeEnt then
    begin
        lbx_NFeEnt.PopupMenu:=PopupMenu1 ;
        lbx_NFe.PopupMenu   :=nil;
        //mnu_Inserir1.Tag :=1;
        //mnu_Limpar1.Tag  :=1;
        Self.Tag :=0;
    end
    else begin
        lbx_NFeEnt.PopupMenu :=nil ;
        lbx_NFe.PopupMenu :=PopupMenu1 ;
        //mnu_Inserir1.Tag :=2;
        //mnu_Limpar1.Tag :=2;
        Self.Tag :=1;
    end;
end;

procedure Tfrm_princ00.OnEND(Sender: TObject);
begin
//  TSWLog.Add('Finalizou serviço (%s:run:OnEND)', [Self.ClassName]);

  btn_exec.Caption  := 'Executar';
  btn_exec.Tag      :=0 ;
  btn_exec.ImageIndex :=2;
  btn_close.Enabled :=True;

  tab_fiscal.TabEnable :=True;
  tab_contr.TabEnable :=True ;
  tab_config.TabEnable :=True ;

//  if process_cod then
//  begin
//    MsgDlg('Informação', process_msg) ;
//  end
//  else
//  begin
//    MsgDlg('Advertência', process_msg, [mbOK], tsOffice2003Olive) ;
//  end;

//  pnl_process.Text :=Format('<FONT color="#004080">%s gerada.</FONT>',[process_tab]);

//  CRec.CExec := nil;

end;

procedure Tfrm_princ00.OnINI(Sender: TObject);
begin

//  ulog.CLog.OnSWLogChange :=Self.OnLOG;

  btn_exec.Caption:= 'Parar';
  btn_exec.Tag    :=1 ;
  btn_exec.ImageIndex :=3;
  btn_close.Enabled :=False;

  pag_control1.ActivePage :=tab_process ;
  tab_fiscal.TabEnable  :=False ;
  tab_contr.TabEnable   :=False ;
  tab_config.TabEnable  :=False;

  mmOnLog.Clear ;

//  TSWLog.Add('Iniciou serviço (%s:run:OnINI)', [Self.ClassName]);

end;

procedure Tfrm_princ00.OnLOG(Sender: TObject; const StrLog: string);
begin
  mmOnLog.Lines.Add(StrLog);

end;

procedure Tfrm_princ00.OnSTR(const aStr: string);
begin
  mmOnLog.Lines.Add(aStr);
end;

procedure Tfrm_princ00.pag_control1Change(Sender: TObject);
begin
  if btn_exec.Tag = 0 then
  begin
    if pag_control1.ActivePageIndex in[0,1] then
    begin
      btn_exec.Enabled :=True ;
    end
    else begin
      btn_exec.Enabled :=False ;
    end;
  end;
end;

function Tfrm_princ00.ValidPeriodo(var F: TFilterEFD): Boolean;
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

procedure Tfrm_princ00.vst_ContabChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  C: Tcadcontab00 ;
begin
  if Assigned(Node) then
  begin
    C :=cadcontab00List.Items[Node.Index];
    C.Checkin :=(Node.CheckState = csCheckedNormal) ;
  end;
end;

procedure Tfrm_princ00.vst_ContabGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  C: Tcadcontab00 ;
begin
  CellText :='' ;
  if Assigned(Node) then
  begin
    C :=cadcontab00List.Items[Node.Index] ;
    if C <> nil then
    begin
      case Column of
        0: CellText :=Tefd_util.FInt(C.ctb00_codigo, 3);
        1: CellText :=C.ctb00_nome;
        2: CellText :=C.ctb00_cpf ;
        3: CellText :=C.ctb00_crc ;
        4: CellText :=Tefd_util.FInt(C.ctb00_codmun);
      end;
    end;
  end;
end;

{$ENDREGION}


{ TCustomComboHlp }

procedure TCustomComboHlp.Add(const AStr: string;
  const AItemIndex: Integer);
begin
  if Pos('","', AStr) = 0 then
    Self.AddItem(AStr, nil)
  else begin
    Self.Items.CommaText :=AStr;
  end;
  Self.ItemIndex :=AItemIndex ;
end;

{ TFolderDialog }

class function TFolderDialog.NewFolderDialog(const ACaption,
  ATitle: string; out ADirectory: string): Boolean;
var
  local: TFolderDialog ;
begin

  local :=TFolderDialog.Create(nil);
  try
    local.Caption :=ACaption ;
    local.Title :=ATitle ;
    local.DialogPosition :=fdpScreenCenter ;
    local.Options :=[fdoBrowseForComputer,fdoNewDialogStyle,fdoNoNewFolderButton] ;
    Result :=local.Execute ;
    if Result then
      ADirectory :=local.Directory
      ;
  finally
    local.Free ;
  end;

end;

{ TJvOpenDialog }

class function TJvOpenDialog.NewOpenDialog(out AFiles: string;
  const ATypDOC: TJvOpenDialogTypDOC): Boolean ;
var
  dlg: TJvOpenDialog ;
begin
  dlg :=TJvOpenDialog.Create(Application.MainForm);
  try
    dlg.Ctl3D :=False ;
    if ATypDOC = dtdEFD then
    begin
      dlg.DefaultExt:='.EFD';
      dlg.Filter    :='Arquivos EFD-ICMS/IPI (*.EFD)|*.EFD';
    end
    else begin
      dlg.DefaultExt:='.XML';
      dlg.Filter    :='Notas Fiscais Eletrônicas NF-e (*.XML)|*.XML';
    end;
    dlg.FilterIndex:=1;
    dlg.InitialDir :=ExcludeTrailingPathDelimiter( ExtractFilePath(Application.ExeName) );
    dlg.Options :=[ofAllowMultiSelect,ofPathMustExist,ofFileMustExist];
    Result :=dlg.Execute(Application.MainForm.Handle) ;
    if Result then
    begin
//      if dlg.Files.Count > 1 then
//        AFiles :=dlg.Files.CommaText
//      else
//        AFiles :=dlg.Files.Text ;
        AFiles :=dlg.Files.CommaText;
    end;
  finally
    dlg.Free
    ;
  end;
end;

class function TJvOpenDialog.ShowSelect: TStrings;
var
  dlg: TJvOpenDialog ;
begin
  Result :=nil ;
  dlg :=TJvOpenDialog.Create(Application.MainForm);
  try
    dlg.Ctl3D :=False ;
    dlg.DefaultExt:='.EFD';
    dlg.Filter    :='Arquivos EFD-ICMS/IPI (*.EFD)|*.EFD';
    dlg.FilterIndex:=1;
    dlg.InitialDir :=ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
    dlg.Options :=[ofAllowMultiSelect,ofPathMustExist,ofFileMustExist];
    if dlg.Execute(Application.MainForm.Handle) then
    begin
      Result :=TStringList.Create ;
      Result.AddStrings(dlg.Files) ;
    end;
  finally
    dlg.Free
    ;
  end;
end;

{ TCProc }

constructor TCProc.Create(const aTypEFD: TtypEFD;
  aCadEmp: Tcademp00; aCadCtb: Tcadcontab00; const aFilter: TFilterEFD);
begin
  inherited Create(True, False);
  m_TypEFD :=aTypEFD ;
  m_CadEmp :=aCadEmp;
  m_CadCtb :=aCadCtb;
  m_Filter :=aFilter;
end;

procedure TCProc.RunContrib;
begin

end;

procedure TCProc.RunICMSIPI;
var
  EFD: TSpedFiscal;
begin

  CallOnStrProc('[%s].Iniciou serviço (%s.RunICMSIPI)', [TEFD_Fiscal.EFD_NAME,Self.ClassName]);
  EFD :=TSpedFiscal.Create;
  try
    EFD.Path:=Format('%s\%.8s-%s\%d',[m_Filter.path, m_CadEmp.CNPJ, m_CadEmp.Nome, YearOf(m_Filter.DtaFin)]);
    EFD.EFD_Fiscal.SetEntidade(m_Filter.CodVer, // cvl106,  //varsão do leiaute
                               cfOrig,  //finalidade do arquivo
                               m_Filter.DtaIni,//data inicio do movimento
                               m_Filter.DtaFin,//data final do movimento
                               perfil_A,//perfil do contribuinte
                               atvOut , //atividade principal do contribuinte
                               m_CadEmp.Nome ,//nome empresarial
                               m_CadEmp.CNPJ ,//CNPJ
                               m_CadEmp.UF   ,//UF
                               m_CadEmp.IE   ,//insc.est
                               m_CadEmp.CodMun,//cod.municipio do IBGE
                               m_CadEmp.CEP ,
                               m_CadEmp.Endere,
                               m_CadEmp.Bairro,
                               m_CadEmp.Fone);

    CallOnStrProc('Entidade: Nome=%s, CNPJ=%s, Mun=%d', [m_CadEmp.Nome, m_CadEmp.CNPJ, m_CadEmp.CodMun]);

    if m_CadCtb <> nil then
    begin
      EFD.EFD_Fiscal.SetContab( m_CadCtb.ctb00_nome,
                                m_CadCtb.ctb00_cpf ,
                                m_CadCtb.ctb00_crc ,
                                m_CadCtb.ctb00_cnpj ,
                                m_CadCtb.ctb00_cep ,
                                m_CadCtb.ctb00_endere ,
                                m_CadCtb.ctb00_bairro , '',
                                m_CadCtb.ctb00_email,
                                m_CadCtb.ctb00_codmun);
      CallOnStrProc('Contabilista: Nome=%s, CPF=%s, CRC=%s CNPJ=%s, Mun=%d',[
          m_CadCtb.ctb00_nome, m_CadCtb.ctb00_cpf, m_CadCtb.ctb00_crc, m_CadCtb.ctb00_cnpj, m_CadCtb.ctb00_codmun
          ]);
    end
    else begin
      CallOnStrProc('Nenhum contabilista encontrado ou marcado!');
    end;

    if EFD.Execute(m_Filter,CallOnStrProc) then
      CallOnStrProc('Processo concluído.'#13'EFD ICMS/IPI gerada com sucesso.')
    else
      CallOnStrProc('Processo cancelado!'#13'Falha na geração EFD ICMS/IPI! Verifique o LOG!');
  finally
    EFD.Free ;
    CallOnStrProc('[%s].Finalisou serviço (%s.RunICMSIPI)', [TEFD_Fiscal.EFD_NAME,Self.ClassName]);
  end;
end;

procedure TCProc.RunProc;
begin
  case m_TypEFD of
    efdICMSIPI: RunICMSIPI;
    efdContrib: RunContrib;
  end;
end;

end.
