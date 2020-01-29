unit EFD00;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  Generics.Defaults, Generics.Collections ,
  DB ,

  DBAccess, uunidac ,
  uclass, ulog ,

  EFDUtils ,
  EFDCommon,
  uefd_fiscal,
  ufisbloco_0 ,
  ufisbloco_H ,
  uefd_contrib,
  uctrbloco_0;


type
  TUpdateStatus = (usNewValue, usUpdateValue, usDeleteValue);
  TBaseCad = class
  private
    FIndex: Integer ;
    FUpdateStatus: TUpdateStatus;
    FCheckin: Boolean ;
    FErrCod: Integer ;
    FErrMsg: string ;
  public
    property Index: Integer read FIndex;
    property UpdateStatus: TUpdateStatus read FUpdateStatus write FUpdateStatus ;
    property Checkin: Boolean read FCheckin write FCheckin;
    property ErrCod: Integer read FErrCod write FErrCod;
    property ErrMsg: string read FErrMsg write FErrMsg;
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
    UF,IE:string ;
    CEP: string ;
    Endere: string;
    Bairro: string ;
    Fone: String;
  end;

  Tcademp00List = class(TList<Tcademp00>)
  public
    function AddNew(const Codigo: Integer): Tcademp00 ;
    function IndexOf(const Codigo: Integer): Tcademp00; overload ;
    function CLoad(StrList: TStrings): Boolean ;
  end;

{$ENDREGION}

{$REGION 'Tcadcontab00List'}
type
  Tcadcontab00List = class;
  Tcadcontab00 = class (TBaseCad)
  private
  public
    ctb00_codigo: Integer;
    ctb00_nome: string ;
    ctb00_cpf: string ;
    ctb00_crc: string ;
    ctb00_cnpj: string;
    ctb00_cep: string ;
    ctb00_endere: string ;
    ctb00_numero: string ;
    ctb00_comple: string ;
    ctb00_bairro: string ;
    ctb00_codmun: Integer;
    ctb00_email: string ;
  end;

  Tcadcontab00List = class(TList<Tcadcontab00>)
  private
//    Query: TUniQuery ;
  public
    function AddNew(const Codigo: Integer): Tcadcontab00;
    function IndexOf(const Codigo: Integer): Tcadcontab00; overload ;
    function CLoad(const Codigo: Integer = 0): Boolean ;
    function ApplyUpdates(AContab: Tcadcontab00): Boolean ;
  end;

{$ENDREGION}

{$REGION 'TLoadEFDTFilter'}
type
  TDocTyp = (docEnt, docSai) ;
  TDocTypSet = set of TDocTyp;
  TDtaTyp = (dtEntr, dtEmis) ;
  TLoadEFDTFilter = record
  public
    CodEmp: Integer ;
    DtaIni: TDateTime;
    DtaFin: TDateTime;
    DocTyp: TDocTypSet;
    //ano/mes do inventário fisico (somente para sped fiscal)
    IndInv:Boolean;
    RefAno,RefMes:Word;
    MotInv:TInvMotivo;
    //
    ecf_fab: string;
    //
    DtaTyp: TDtaTyp ;
    NoRegC400: Boolean ;
  end;

{$ENDREGION}

{$REGION 'TBaseLoadEFD'}
type
  TBaseLoadEFD = class
  private
    const COD_LOAD_SUCESS = 0 ;
    const COD_LOAD_MOD55_EMPTY = 101 ;
    const COD_LOAD_MOD2D_EMPTY = 103 ;
    const COD_LOAD_ERROR = 999 ;
    const COD_FIELD_NOT_FOUND = 200 ;
  private
    class var Instance: TBaseLoadEFD;
  private
    // classes var´s entidade
    class var femp_codigo: TField;
    class var femp_nome  : TField;
    class var femp_cnpj  : TField;
    class var femp_ie : TField  ;
    class var femp_cep   : TField;
    class var femp_logr: TField;
    class var femp_endere: TField;
    class var femp_numero: TField;
    class var femp_bairro: TField;
    class var femp_ddd   : TField;
    class var femp_fone  : TField;
    class var femp_codmun: TField;
    class var femp_uf: TField ;

    // participante
    class var
      fpart_cod ,
      fpart_nome,
      fpart_typpes ,
      fpart_cpf,
      fpart_cnpj,
      fpart_ie     ,
      fpart_endere ,
      fpart_bairro ,
      fpart_codmun,
      fpart_uf: TField ;

    // doc fiscal
    class var
      find_oper	,
      find_emit	,
      fcod_mod	,
      fcod_sit	,
      fser_doc	,
      fsub_ser  ,
      fnum_doc	,
      fchv_nfe	,
      fdta_emi	,
      fdta_e_s	,
      fvlr_desc	,
      find_fret	,
      fvlr_fret	,
      fvlr_out_da,
      fnat_oper,
      fqtd_item ,
      fvlr_unit ,
      fvlr_item	,
      fvlr_tot ,
      fcst_icms ,
      fcfop   	,
      faliq_icms ,
      fvlr_bc_icms,
      fvlr_icms,
      fvlr_rbc,faliq_rbc,
      fvlr_bc_icmsst,
      fvlr_icmsst   ,
      fvlr_bc_ipi ,
      faliq_ipi ,
      fvlr_ipi: TField;

      finc_fret,
      fvlr_bc_fret,
      fvlr_icmsfret,
      fcanc_item,fcod_tot: TField;
      fid_mov: TField;

    // Items
    class var
      fcod_item ,
      fdescr_item,
      fcod_barra ,
      funid_inv ,
      fcod_ncm ,
      fcod_gen:TField	;
      fcls_fis: TField;
      fcst_pis, fcst_cofins: TField;
      faliq_pis, faliq_cofins: TField;

    // ECF
    class var
      fecf_mod ,
      fecf_fab,
      fnum_cx ,
      fdt_doc ,
      fcro ,
      fcrz ,
      fnum_coo_ini,fnum_coo_fin,
      fgt_fin,
      fvl_brt ,
      fcod_tot_par,
      fvl_acum_tot: TField;
      fmov_count: TField;

  private
    EFD: TBaseEFD ;
    function LoadDocFis01(): TUniQuery; virtual ; // ICMS/IPI
//    procedure DoLoadDocFis01(out Q: TUniQuery); virtual ; // ICMS/IPI

  protected
    Filter: TLoadEFDTFilter;
    RetCod: Integer;
    RetMsg: string ;
    Stop: Boolean;

  protected
    mov_codseq: Cardinal;

    ind_ope: TIndTypOper;
    ind_emi: TIndEmiDoc ;
    cod_sit: TCodSitDoc ;
    cod_mod: string ;
    ser_doc: string ;
    num_doc: Integer;
    chv_nfe: string;

    cod_item: string;
    descr_item: string ;
    und_item: string;
    qtd_item: Currency;
    vlr_unit: Currency;
    vlr_item: Currency;
    vlr_tot: Currency;
    vlr_desc: Currency;
    cod_barra: string ;
    cod_ncm: string ;
    cod_gen: Integer;

    cst_icms, cfop: Word;
    vbc_icms  , aliq_icms   , vlr_icms  : Currency;
    vbc_icmsst, aliq_icmsst , vlr_icmsst: Currency;

    aliq_rbc, vlr_rbc: Currency;
    vlr_ipi: Currency;

    vlr_fret: Currency;
    vlr_out_da: Currency;

    id_mov: Cardinal ;

  	part_cod: string ;
  	part_nome: string;
  	part_cpf: string;
    part_cnpj: string;
  	part_ie: string;
  	part_endere: string;
  	part_bairro: string;
  	part_codmun: Integer;
    part_uf: string ;

    procedure DoInitVars(const AReg_C400: Boolean) ;
  public
    constructor Create (ABaseEFD: TBaseEFD); reintroduce ;
    destructor Destroy; override ;
    function Execute(AFilter: TLoadEFDTFilter): Boolean; virtual ;
    procedure DoStop();
    class function GetInstance: TBaseLoadEFD ;
  end;

{$ENDREGION}

{$REGION 'TLoadEFDICMSIPI'}
type
  TLoadEFDICMSIPI = class(TBaseLoadEFD)
    ForceRegC170: Boolean;
    EFD_Fiscal: TEFD_Fiscal;
  private
    function LoadDocFis01(): TUniQuery; override ;
  public
    constructor Create;
    destructor Destroy; override;

  end;

{$ENDREGION}

{$REGION 'TLoadEFDContrib'}
  type
    TLoadEFDContrib = class(TBaseLoadEFD)
    private
    public
    end;

{$ENDREGION}


type
//  TDocTyp = (docEnt, docSai) ;
//  TDocTypSet = set of TDocTyp;
//  TDtaTyp = (dtEntr, dtEmis) ;
  TFilterEFD = record
  public
    CodEmp: Integer ;
    CodVer: TCodVerLay;
    DtaIni: TDateTime;
    DtaFin: TDateTime;
    DocTyp: TDocTypSet;
    //ano/mes do inventário fisico (somente para sped fiscal)
    IndInv:Boolean;
    RefAno,RefMes:Word;
    MotInv:TInvMotivo;
    //
    ecf_fab,path: string;
    //
    DtaTyp: TDtaTyp ;
    NoRegC400: Boolean;
    EFD_Saidas: TStrings;
    EFD_NFe: TStrings;
    EFD_NFeEnt: TStrings;
  end;

  TLoadEFD = class
    CodCta_Ent: string ;
    CodCta_Sai: string ;
  private
    const COD_LOAD_SUCESS = 0 ;
    const COD_LOAD_MOD55_EMPTY = 100 ;
    const COD_LOAD_MOD2D_EMPTY = 200 ;
    const COD_FIELD_NOT_FOUND = 110 ;
    const COD_LOAD_ERROR = 999 ;
  private
    EFD: TBaseEFD ;
    class var Instance: TLoadEFD;
  private
    // entidade (empresa)
    femp_codigo:TField;
    femp_nome  :TField;
    femp_cnpj  :TField;
    femp_ie :TField  ;
    femp_cep   :TField;
    femp_logr: TField;
    femp_endere:TField;
    femp_numero:TField;
    femp_bairro:TField;
    femp_ddd   :TField;
    femp_fone  :TField;
    femp_codmun:TField;
    femp_uf:TField  ;

  private
    // participante
  	fpart_cod ,
  	fpart_nome,
  	fpart_typpes,
  	fpart_cpf,
    fpart_cnpj,
  	fpart_ie     ,
  	fpart_endere ,
  	fpart_bairro ,
  	fpart_codmun,
    fpart_uf:TField;

  	part_cod: string ;
  	part_nome: string;
  	part_cpf: string;
    part_cnpj: string;
  	part_ie: string;
  	part_endere: string;
  	part_bairro: string;
  	part_codmun: Integer;
    part_uf: string ;
  private
    // doc fiscal
    find_oper	,
		find_emit	,
		fcod_mod	,
    fcod_sit	,
    fser_doc	,
    fsub_ser  ,
    fnum_doc	,
    fchv_nfe	,
    fdta_emi	,
    fdta_e_s	,
    fvlr_desc	,
    find_fret	,
    fvlr_fret	,
    fvlr_out_da,
    fnat_oper,
    fqtd_item ,
    fvlr_unit ,
    fvlr_item	,
    fvlr_tot ,
    fcst_icms ,
    fcfop   	,
    faliq_icms ,
    fvlr_bc_icms,
    fvlr_icms,
    fvlr_rbc,faliq_rbc,
    fvlr_bc_icmsst,
    fvlr_icmsst   ,
    fvlr_bc_ipi ,
    faliq_ipi ,
    fvlr_ipi: TField;
    finc_fret,
    fvlr_bc_fret,
    fvlr_icmsfret,
    fcanc_item,fcod_tot: TField;
    fid_mov: TField;
  private
    // Item
    fcod_item ,
    fdescr_item,
    fcod_barra ,
    funid_inv ,
    fcod_ncm ,
    fcod_gen:TField	;
    fcls_fis: TField;
    fcst_pis, fcst_cofins: TField;
    faliq_pis, faliq_cofins: TField;
  private
    fecf_mod ,
    fecf_fab,
    fnum_cx ,

    fdt_doc ,
    fcro ,
    fcrz ,
    fnum_coo_ini,fnum_coo_fin,
    fgt_fin,
    fvl_brt ,

    fcod_tot_par,
    fvl_acum_tot:TField;

    fmov_count:TField;

  protected
    ind_ope: TIndTypOper;
    ind_emi: TIndEmiDoc ;
    cod_sit: TCodSitDoc ;
    cod_mod: string ;
    ser_doc: string ;
    num_doc: Integer;
    chv_nfe: string;

    cod_item: string;
    descr_item: string ;
    und_item: string;
    qtd_item: Currency;
    vlr_unit: Currency;
    vlr_item: Currency;
    vlr_tot: Currency;
    vlr_desc: Currency;
    cod_barra: string ;
    cod_ncm: string ;
    cod_gen: Integer;

    cst_icms, cfop: Word;
    vbc_icms  , aliq_icms   , vlr_icms  : Currency;
    vbc_icmsst, aliq_icmsst , vlr_icmsst: Currency;

    aliq_rbc, vlr_rbc: Currency;
    vlr_ipi,aliq_ipi: Currency;

    vlr_fret: Currency;
    vlr_out_da: Currency;

    id_mov: Cardinal ;

    Stop: Boolean;

    ecf_mod, ecf_fab: string;

    procedure SetVars(const AReg_C400: Boolean) ;

  protected
    filter: TfilterEFD;
    fPath: string ;
    fRetCod: Integer;
    fRetMsg: string ;
    fFileName: TFileName;
    function LoadEmpresa(const codfil: Integer = 1): TUniQuery ;

    function LoadDocFis01(): {$IFDEF ZEOS } TQueryDBZ; {$ELSE} TUniQuery ; {$ENDIF} // ICMS/IPI

    function LoadDocFis01_C400(): TUniQuery ; // ICMS/IPI - REGISTRO C400
    function LoadDocFis01_C460(const cod_emp: Integer; const ecf_fab: string;
      const dt_mov: TDate): TUniQuery ; // ICMS/IPI - REGISTRO C460

    function LoadDocFis02(): {$IFDEF ZEOS } TQueryDBZ; {$ELSE} TUniQuery ; {$ENDIF} // ICMS/SERVIÇOS

    procedure get_PIS_COFINS(const ind_oper: TIndTypOper;
      const cls_fis, cfop: Word;
      var pis_cst: Word; var pis_aliq: Currency;
      var cofins_cst: Word; var cofins_aliq: Currency);

    procedure get_InfoDoc(const IndOpe: TIndTypOper; var ChvNfe: string;
      out CodMod: string ; out NumDoc: Integer; out NumSer: string);

  public
    property Path: string read fPath write fPath;
    property RetCod: Integer read fRetCod;
    property RetMsg: string  read fRetMsg;
    property FileName: TFileName read fFileName;
  public
    constructor Create ;
    destructor Destroy; override ;
    procedure DoStop();
    class function GetInstance: TLoadEFD ;
  end;

  TSpedFiscal = class (TLoadEFD)
    CodFinaly: TCodFinaly;
    Perfil: TPerfil;
    ForceRegC170: Boolean;
    NoDocSaiCancel: Boolean;
  protected
    procedure DoFillEFD;
    procedure DoFillEFD_C100FromFile(const AFileName: string;
      const EmiDoc: TIndEmiDoc = emiProp);
    procedure DoFillEFD_C400;
    procedure DoFillEFD_C400FromFile(const AFileName: string);
    procedure DoFillBD ;
    procedure DoLoadBH();
  public
    EFD_Fiscal: TEFD_Fiscal;
    constructor Create;
    destructor Destroy; override;
    function Load(AFilter: TfilterEFD): Word;
    function Execute(AFilter: TfilterEFD; p:TGetStrProc): Boolean;
    function LoadFromDir(const ALocalDir: string): Boolean;
  end;

  TSpedContrib = class(TLoadEFD)
    IndTipEsc: TIndTypEsc;
    IndSitEsp: TIndSitEsp;
    CodEmp: Integer ;
    Nome: string;
    CNPJ: string;
    UF: string ;
    IE: string ;
    CodMun: Integer;
    IndNatPJ: TIndNatPJ;
    IndTipAtv: TIndTypAtiv;
  protected
    procedure DoFillEFD;
    procedure DoFillEFD_C100FromFile(const AFileName: string;
      const EmiDoc: TIndEmiDoc = emiProp);
    procedure DoFillEFD_C400;
    procedure DoFillEFD_C400FromFile(const AFileName: string);
    procedure DoFillBD ;
  public
    EFD_Contrib :TEFD_Contrib;
    constructor Create;
    destructor Destroy; override ;
    function Execute(AFilter: TfilterEFD): Boolean;
  end;

procedure AddLog(const AMsg: string); overload;
procedure AddLog(const AFormat: string; const Args: array of const); overload;

var
  cadcontab00List: Tcadcontab00List = nil ;

implementation

uses DateUtils, StrUtils, Math, MaskUtils,
  JvSearchFiles ,
  ufisbloco_C ,
  ufisbloco_D ,
  uctrbloco_C ,

  uctrbloco_D
  ,unfexml
  ;

var
  proc: TGetStrProc ;


procedure AddLog(const AMsg: string); overload;
begin
  if TLoadEFD.GetInstance <> nil then
  begin
    if TLoadEFD.GetInstance.EFD is TEFD_Fiscal then
      TSWLog.Add('[%s].%s',[TEFD_Fiscal.EFD_NAME,AMsg])
    else
      TSWLog.Add('[%s].%s',[TEFD_Contrib.EFD_NAME,AMsg]) ;
  end
  else
    TSWLog.Add(AMsg);
//  if Assigned(CLog) then
//  begin
//    CLog.AddLog('EFD.' + message);
//  end;
//
//  if Assigned(OnLogAdd) then
//  begin
//    OnLogAdd(nil, message);
//  end;
end;

procedure AddLog(const AFormat: string; const Args: array of const); overload;
begin
  AddLog(Format(AFormat, Args));
//  try
//    AddLog(format(cformat, args));
//  except
//    AddLog(cformat);
//  end;
end;


{ TLoadEFD }

constructor TLoadEFD.Create;
begin
  Instance :=Self
  ;

end;

destructor TLoadEFD.Destroy;
begin
  Instance :=nil
  ;
  inherited;
end;

procedure TLoadEFD.DoStop();
begin
  Stop :=True;
  if EFD is TEFD_Fiscal then
    AddLog('Processo de geração da EFD-ICMS/IPI paralisado pelo usuário!')
  else
    AddLog('Processo de geração da EFD-Contribuíções paralisado pelo usuário!');
end;

class function TLoadEFD.GetInstance: TLoadEFD;
begin
  if Assigned(Instance) then
    Result :=Instance
  else
    Result :=nil ;
end;

procedure TLoadEFD.get_InfoDoc(const IndOpe: TIndTypOper; var ChvNfe: string;
  out CodMod: string; out NumDoc: Integer;
  out NumSer: string);
begin

  if IndOpe = toEnt then
  begin
    if Length(ChvNfe)=44 then
    begin
      if(ChvNfe[21]='5')and(ChvNfe[22]='5')then
      begin
        CodMod :='55';
        NumDoc :=StrToIntDef(Copy(ChvNfe, 26, 9), 0);
        NumSer :=Copy(ChvNfe, 23, 3) ;
      end
      else begin
        CodMod :='01';
        ChvNfe :='';
      end;
    end
    else begin
      CodMod :='01';
      ChvNfe :='';
    end;
  end;

end;

procedure TLoadEFD.get_PIS_COFINS(const ind_oper: TIndTypOper;
  const cls_fis, cfop: Word;
  var pis_cst: Word; var pis_aliq: Currency;
  var cofins_cst: Word; var cofins_aliq: Currency);
begin
    case ind_oper of
        toEnt:// CST PIS/COFINS - ENTRADA
        if Tefd_util.CFOP_In(cfop,[1910,2910]) then
        begin
            // Operação de Aquisição a Alíquota Zero
            pis_cst  :=73;
            pis_aliq :=0 ;
            cofins_cst :=pis_cst;
            cofins_aliq:=pis_aliq;
        end

        else if Tefd_util.CFOP_In(cfop,[1409,2409,1551,2551,1556,2556,1557,2922,2923,2949])then
        begin
            // Outras Operações de Entrada
            pis_cst  :=98;
            pis_aliq :=0 ;
            cofins_cst :=pis_cst;
            cofins_aliq:=pis_aliq;
        end

        else begin
            if cls_fis in[1..4,9] then
            begin
                pis_cst :=50; // Operação com Direito a Crédito - Vinculada Exclusivamente a
                              // Receita Tributada no Mercado Interno
                if pis_aliq<>TDefValue.ALIQ_PIS then
                begin
                    pis_aliq :=TDefValue.ALIQ_PIS ;
                end;
                cofins_cst :=pis_cst;
                if cofins_aliq<>TDefValue.ALIQ_COFINS then
                begin
                    cofins_aliq :=TDefValue.ALIQ_COFINS;
                end;
            end

            else if cls_fis >= 5 then
            begin
                // Operação de Aquisição a Alíquota Zero
                pis_cst  :=73;
                pis_aliq :=0 ;
                cofins_cst :=pis_cst;
                cofins_aliq:=pis_aliq;
            end;
        end;

        toSai:// CST PIS/COFINS - SAIDA
        if (cls_fis in[1..4])or(Tefd_util.CFOP_In(cfop,[5910,6910])) then
        begin
            pis_cst :=1; // Operação Tributável com Alíquota Básica
            if pis_aliq<>TDefValue.ALIQ_PIS then
            begin
                pis_aliq :=TDefValue.ALIQ_PIS ;
            end;
            cofins_cst :=pis_cst;
            if cofins_aliq<>TDefValue.ALIQ_COFINS then
            begin
                cofins_aliq :=TDefValue.ALIQ_COFINS;
            end;
        end
        else if cls_fis >= 5 then
        begin
            // Operação Tributável a Alíquota Zero
            pis_cst  :=6;
            pis_aliq :=0 ;
            cofins_cst :=pis_cst;
            cofins_aliq:=pis_aliq;
        end;
    end;

end;

function TLoadEFD.LoadDocFis01(): {$IFDEF ZEOS } TQueryDBZ; {$ELSE} TUniQuery ; {$ENDIF}
begin
    fRetCod :=TLoadEFD.COD_LOAD_SUCESS;
    fRetMsg :='';

    {$IFDEF ZEOS }
      Result :=NewQueryDBZ(CDataBase);
    {$ELSE}
      Result :=TUniQuery.NewQuery();
    {$ENDIF}

    Result.sql.Add('--/** EFD00.pas **/                      ');
//    Result.sql.Add('declare @codfil smallint; set @codfil=%d ',[filter.CodEmp]);
//    Result.sql.Add('declare @dtaini datetime; set @dtaini=%s ',[Result.SQLFun.SDatSQL(filter.DtaIni)]);
//    Result.sql.Add('declare @dtafin datetime; set @dtafin=%s ',[Result.SQLFun.SDatSQL(filter.DtaFin,True)]);

    with Result.sql do
    begin
        // ********
        // entradas
        // ********
        if docEnt in filter.DocTyp then
        begin
          Add('select                                                            ');

          Add('  emp.id_filial as emp_codigo,                                    ');
          Add('  emp.nome  as emp_nome   ,                                       ');
          Add('  emp.cnpj  as emp_cnpj   ,                                       ');
          Add('  emp.ie  as emp_ie    ,                                          ');
          Add('  emp.cep as emp_cep   ,                                          ');
          Add('  emp.tipo_logradouro as emp_logr,                                ');
          Add('  emp.logradouro    as emp_endere,                                ');
          Add('  emp.numero    as emp_numero,                                    ');
          Add('  emp.bairro  as emp_bairro,                                      ');
          Add('  emp.tel    as emp_fone  ,                                       ');
          Add('  emp.codigo_municipio as emp_codmun,                             ');
          Add('  emp.uf  as emp_uf,                                              ');

          Add('  par.id_fornecedor as part_cod,                                  ');
          Add('  pes.nome as part_nome    ,                                      ');
          Add('  pes.tipo_pessoa as part_typpes  ,                               ');
          Add('  case when pes.tipo_pessoa=0 then pes.cpf_cnpj end  as part_cpf ,');
          Add('  case when pes.tipo_pessoa=1 then pes.cpf_cnpj end  as part_cnpj,');
          Add('  pes.rg as part_ie      ,                                        ');
          Add('  pes.logradouro   as part_endere  ,                              ');
          Add('  pes.bairro as part_bairro  ,                                    ');
          Add('  mun.codigo_fiscal as part_codmun ,                              ');
          Add('  mun.uf  as part_uf ,                                            ');

          Add('  mov.id_movimento as id_mov,                                     ');
          Add('  mov.tipo_mov  as ind_oper,                                      ');
          Add('  1  as ind_emit,                                                 ');
          Add('  55 as cod_mod ,                                                 ');
          Add('  case mov.cancelado when 1 then 02                               ');
          Add('  else 00 end as cod_sit,                                         ');
          Add('  1  as ser_doc,                                                  ');
          Add('  cast(mov.numero_doc as int) as num_doc,                         ');
          Add('  mov.nfe_chave as chv_nfe,                                       ');
          Add('  mov.dt_emissao as dta_emi ,                                     ');
          Add('  mov.dt_movimento  as dta_e_s    ,                               ');
          Add('  0  as nat_oper ,                                                ');
          Add('  9  as ind_fret,                                                 ');
          Add('  0  as vlr_fret ,                                                ');

          Add('  itm.valor_outras as vlr_out_da,                                 ');
          Add('  itm.valor_desconto as vlr_desc ,                                ');
          Add('  itm.quantidade as qtd_item,                                     ');
          Add('  itm.valor_unitario as vlr_unit,                                 ');
          Add('  case when itm.situacao_tributaria is null then 0                ');
          Add('  else itm.situacao_tributaria end as cst_icms ,                  ');
          Add('  itm.cfop  as cfop ,                                             ');
          Add('  itm.base_icms as vlr_bc_icms,                                   ');
          Add('  itm.percentual_icms as aliq_icms ,                              ');
          Add('  itm.valor_icms  as vlr_icms,                                    ');
          Add('  itm.base_substuicao as vlr_bc_icmsst,                           ');
          Add('  itm.percentual_substituicao as aliq_icmsst ,                    ');
          Add('  itm.valor_substituicao  as vlr_icmsst   ,                       ');
          Add('  itm.percentual_ipi as aliq_ipi     ,                            ');
          Add('  itm.valor_ipi as vlr_ipi      ,                                 ');
          Add('  0.00 as vlr_rbc  ,                                              ');

          Add('  pro.percentual_reducao as aliq_rbc,                             ');
          Add('  pro.id_item  as cod_item     ,                                  ');
          Add('  pro.descricao  as descr_item ,                                  ');
          Add('  pro.cod_barra  as cod_barra ,                                   ');
          Add('  pro.unidade  as unid_inv ,                                      ');
          Add('  pro.ncm as cod_ncm ,                                            ');
          Add('  pro.pis as aliq_pis  ,                                          ');
          Add('  pro.cofins as aliq_cofins                                       ');

          Add('  ,case when pro.classe_pis is null then 99 else pro.classe_pis end as cst_pis           ');
          Add('  ,case when pro.classe_cofins is null then 99 else pro.classe_cofins end as cst_cofins  ');

          Add(' ,%d as cod_gen                                                    ', [TDefValue.COD_GEN_ITEM]);

          Add('from movimento mov                                                ');
          Add('inner join filial emp on emp.id_filial = mov.id_filial            ');
          Add('inner join fornecedor par on par.id_fornecedor = mov.id_fornecedor');
          Add('inner join pessoa pes on pes.id_pessoa         = par.id_pessoa    ');
          Add('inner join municipio mun on mun.id_municipio   = pes.id_municipio ');
          Add('inner join itens_mov itm on itm.id_movimento    = mov.id_movimento');
          Add('left join item pro on pro.id_item              = itm.id_item      ');

          if filter.CodEmp >= 1 then
          begin
            Add('where mov.id_filial =%d                                     ',[Self.filter.CodEmp]);
            Add('and   mov.tipo_mov  =0                                      ');
          end
          else begin
            Add('where mov.tipo_mov  =0                                      ');
          end;

          if filter.DtaTyp = dtEntr then
          begin
            Add('and   mov.dt_movimento between :dt_ini1 and :dt_fin1        ');
          end
          else begin
            Add('and   mov.dt_emissao between :dt_ini1 and :dt_fin1          ');
          end;

          Result.AddParamDat('dt_ini1', Self.filter.DtaIni) ;
          Result.AddParamDat('dt_fin1', Self.filter.DtaFin) ;
        end;
        //
        if filter.DocTyp=[docEnt,docSai] then
        begin
          Add('');
          Add('union all                                                       ');
          Add('');
        end;

        // *****************
        // saidas/devolucoes
        // *****************
        if docSai in filter.DocTyp then
        begin
          Add('select                                                           ');

          Add('  emp.id_filial as emp_codigo,                                   ');
          Add('  emp.nome  as emp_nome   ,                                      ');
          Add('  emp.cnpj  as emp_cnpj   ,                                      ');
          Add('  emp.ie  as emp_ie    ,                                         ');
          Add('  emp.cep as emp_cep   ,                                         ');
          Add('  emp.tipo_logradouro as emp_logr,                               ');
          Add('  emp.logradouro    as emp_endere,                               ');
          Add('  emp.numero    as emp_numero,                                   ');
          Add('  emp.bairro  as emp_bairro,                                     ');
          Add('  emp.tel    as emp_fone  ,                                      ');
          Add('  emp.codigo_municipio as emp_codmun,                            ');
          Add('  emp.uf  as emp_uf                                              ');

          Add('  par.id_cliente as part_cod,                                     ');
          Add('  pes.nome as part_nome    ,                                      ');
          Add('  pes.tipo_pessoa as part_typpes  ,                               ');
          Add('  case when pes.tipo_pessoa=0 then pes.cpf_cnpj end  as part_cpf ,');
          Add('  case when pes.tipo_pessoa=1 then pes.cpf_cnpj end  as part_cnpj,');
          Add('  pes.rg as part_ie      ,                                        ');
          Add('  pes.logradouro   as part_endere  ,                              ');
          Add('  pes.bairro as part_bairro  ,                                    ');
          Add('  mun.codigo_fiscal as part_codmun ,                              ');
          Add('  mun.uf  as part_uf ,                                            ');

          Add('  mov.id_movimento as id_mov,                                     ');
          Add('  mov.tipo_mov  as ind_oper,                                      ');
          Add('  1  as ind_emit,                                                 ');
          Add('  55 as cod_mod ,                                                 ');
          Add('  case mov.nfe_cstat when 100 then 00                             ');
          Add('                     when 101 then 02                             ');
          Add('                     when 102 then 05                             ');
          Add('                     when 110 then 04                             ');
          Add('                     when 204 then 00                             ');
          Add('  else 00 end as cod_sit,                                         ');
          Add('  1  as ser_doc,                                                  ');
          Add('  mov.numero_doc as num_doc,                                      ');
          Add('  mov.nfe_chave as chv_nfe,                                       ');
          Add('  mov.dt_emissao as dta_emi ,                                     ');
          Add('  mov.dt_movimento  as dta_e_s    ,                               ');
          Add('  0  as nat_oper ,                                                ');
          Add('  9  as ind_fret,                                                 ');
          Add('  0  as vlr_fret ,                                                ');

          Add('  itm.valor_outras as vlr_out_da,                                 ');
          Add('  itm.valor_desconto as vlr_desc ,                                ');
          Add('  itm.quantidade as qtd_item,                                     ');
          Add('  itm.valor_unitario as vlr_unit,                                 ');
          Add('  itm.situacao_tributaria as cst_icms ,                           ');
          Add('  itm.cfop  as cfop ,                                             ');
          Add('  itm.base_icms as vlr_bc_icms,                                   ');
          Add('  itm.percentual_icms as aliq_icms ,                              ');
          Add('  itm.valor_icms  as vlr_icms,                                    ');
          Add('  itm.base_substuicao as vlr_bc_icmsst,                           ');
          Add('  itm.percentual_substituicao as aliq_icmsst ,                    ');
          Add('  itm.valor_substituicao  as vlr_icmsst   ,                       ');
          Add('  itm.percentual_ipi as aliq_ipi     ,                            ');
          Add('  itm.valor_ipi as vlr_ipi      ,                                 ');
          Add('  0.00 as vlr_rbc  ,                                              ');

          Add('  pro.percentual_reducao as aliq_rbc,                             ');
          Add('  pro.id_item  as cod_item     ,                                  ');
          Add('  pro.descricao  as descr_item ,                                  ');
          Add('  pro.cod_barra  as cod_barra ,                                   ');
          Add('  pro.unidade  as unid_inv ,                                      ');
          Add('  pro.ncm as cod_ncm ,                                            ');
          Add('  pro.pis as aliq_pis  ,                                          ');
          Add('  pro.cofins as aliq_cofins,                                      ');

          Add('  case when pro.classe_pis_saida is null then 99 else pro.classe_pis_saida end as cst_pis,           ');
          Add('  case when pro.classe_cofins_saida is null then 99 else pro.classe_cofins_saida end as cst_cofins,  ');

          Add(' %d as cod_gen                                                    ', [TDefValue.COD_GEN_ITEM]);

          Add('from movimento mov                                                ');
          Add('inner join filial emp on emp.id_filial = mov.id_filial            ');
          Add('inner join cliente par on par.id_fornecedor = mov.id_cliente ');
          Add('inner join pessoa pes on pes.id_pessoa         = par.id_pessoa    ');
          Add('inner join municipio mun on mun.id_municipio   = pes.id_municipio ');
          Add('inner join itens_mov itm on itm.id_movimento   = mov.id_movimento ');
          Add('left join item pro on pro.id_item              = itm.id_item      ');

          if filter.CodEmp >= 1 then
          begin
            Add('where mov.id_filial =%d                                     ',[Self.filter.CodEmp]);
            Add('and   mov.tipo_mov  =1                                      ');
          end
          else begin
            Add('where mov.tipo_mov  =1                                      ');
          end;
//          if filter.DtaTyp = dtEntr then
//          begin
//            Add('and   mov.dt_movimento between :dt_ini2 and :dt_fin2        ');
//          end
//          else begin
//            Add('and   mov.dt_emissao between :dt_ini2 and :dt_fin2          ');
//          end;
          Add('and   mov.dt_emissao between :dt_ini2 and :dt_fin2            ');
          Result.AddParamDat('dt_ini2', Self.filter.DtaIni) ;
          Result.AddParamDat('dt_fin2', Self.filter.DtaFin) ;
        end;
        //
        Add('order by emp_codigo,                                           ');
        Add('         ind_oper  ,                                           ');
        Add('         num_doc   ,                                           ');
        Add('         cod_item                                              ');
    end;

    try
        Result.sql.SaveToFile('0.sql');
        Result.Open ;
        if Result.IsEmpty then
        begin
            fRetCod :=TLoadEFD.COD_LOAD_MOD55_EMPTY;
            fRetMsg :='Nenhum registro encontrado!';
        end;
    except
        on E:EDatabaseError do
        begin
            fRetCod :=TLoadEFD.COD_LOAD_ERROR;
            fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
        end;
    end;

    if fRetCod in[TLoadEFD.COD_LOAD_SUCESS, TLoadEFD.COD_LOAD_MOD55_EMPTY] then
    try
        femp_codigo :=Result.Field('emp_codigo');
        femp_nome   :=Result.Field('emp_nome') ;
        femp_cnpj   :=Result.Field('emp_cnpj') ;
        femp_ie     :=Result.Field('emp_ie') ;
        femp_cep    :=Result.Field('emp_cep') ;
        femp_endere :=Result.Field('emp_endere');
        femp_bairro :=Result.Field('emp_bairro');
//        femp_ddd    :=Result.Field('emp_ddd') ;
        femp_fone   :=Result.Field('emp_fone') ;
        femp_codmun :=Result.Field('emp_codmun');
        femp_uf     :=Result.Field('emp_uf') ;

        fpart_cod	  :=Result.Field('part_cod') ;
        fpart_nome  :=Result.Field('part_nome');
        fpart_typpes:=Result.Field('part_typpes');
        fpart_cpf   :=Result.Field('part_cpf') ;
        fpart_cnpj  :=Result.Field('part_cnpj');
        fpart_ie    :=Result.Field('part_ie') ;
        fpart_endere:=Result.Field('part_endere');
        fpart_bairro:=Result.Field('part_bairro');
        fpart_codmun:=Result.Field('part_codmun');
        fpart_uf		:=Result.Field('part_uf') ;

        fid_mov	:=Result.Field('id_mov') ;
        find_oper	:=Result.Field('ind_oper') ;
        find_emit	:=Result.Field('ind_emit') ;
        fcod_mod	:=Result.Field('cod_mod') ;
        fcod_sit	:=Result.Field('cod_sit') ;
        fser_doc	:=Result.Field('ser_doc') ;
        fnum_doc	:=Result.Field('num_doc') ;
        fchv_nfe	:=Result.Field('chv_nfe') ;
        fdta_emi	:=Result.Field('dta_emi') ;
        fdta_e_s	:=Result.Field('dta_e_s') ;
        fnat_oper :=Result.Field('nat_oper');

        find_fret :=Result.Field('ind_fret') ;
//        finc_fret :=Result.Field('inc_fret') ;
        fvlr_fret :=Result.Field('vlr_fret') ;
        fvlr_out_da:=Result.Field('vlr_out_da');
        fvlr_desc  :=Result.Field('vlr_desc');
        fqtd_item  :=Result.Field('qtd_item');
        fvlr_unit  :=Result.Field('vlr_unit');
//        fvlr_tot   :=Result.Field('vlr_tot') ;

//        fcls_fis   :=Result.Field('cls_fis');
        fcst_icms  :=Result.Field('cst_icms');
        fcfop   	 :=Result.Field('cfop') ;
        faliq_icms :=Result.Field('aliq_icms');
        fvlr_bc_icms:=Result.Field('vlr_bc_icms');
        fvlr_icms		:=Result.Field('vlr_icms') ;
        fvlr_bc_icmsst:=Result.Field('vlr_bc_icmsst');
        fvlr_icmsst   :=Result.Field('vlr_icmsst') ;
        faliq_ipi     :=Result.Field('aliq_ipi') ;
        fvlr_ipi      :=Result.Field('vlr_ipi') ;
        fvlr_rbc      :=Result.Field('vlr_rbc') ;
        faliq_rbc      :=Result.Field('aliq_rbc') ;

//        fvlr_bc_fret :=Result.Field('vlr_bc_fret') ;
//        fvlr_icmsfret:=Result.Field('vlr_icmsfret') ;

        fcod_item :=Result.Field('cod_item');
        fdescr_item :=Result.Field('descr_item');
        fcod_barra :=Result.Field('cod_barra');
        funid_inv :=Result.Field('unid_inv');
        fcod_ncm :=Result.Field('cod_ncm');
        fcod_gen :=Result.Field('cod_gen');
        faliq_pis :=Result.Field('aliq_pis');
        faliq_cofins :=Result.Field('aliq_cofins');

        fcst_pis :=Result.Field('cst_pis');
        fcst_cofins :=Result.Field('cst_cofins');
    except
        on E:EDatabaseError do
        begin
          fRetCod :=TLoadEFD.COD_FIELD_NOT_FOUND;
          fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now), E.Message]);
        end;
    end;
end;

function TLoadEFD.LoadDocFis01_C400: TUniQuery;
begin

  fRetCod :=TLoadEFD.COD_LOAD_SUCESS;
  fRetMsg :='';

  Result :=TUniQuery.NewQuery();

  Result.sql.Add('--/** EFD00.pas **/                                                 ');
  Result.sql.Add('select                                                              ');

  Result.sql.Add('  emp.id_filial as emp_codigo,                                      ');
  Result.sql.Add('  emp.nome  as emp_nome   ,                                         ');
  Result.sql.Add('  emp.cnpj  as emp_cnpj   ,                                         ');
  Result.sql.Add('  emp.ie  as emp_ie    ,                                            ');
  Result.sql.Add('  emp.cep as emp_cep   ,                                            ');
  Result.sql.Add('  emp.tipo_logradouro as emp_logr,                                  ');
  Result.sql.Add('  emp.logradouro    as emp_endere,                                  ');
  Result.sql.Add('  emp.numero    as emp_numero,                                      ');
  Result.sql.Add('  emp.bairro  as emp_bairro,                                        ');
  Result.sql.Add('  emp.tel    as emp_fone  ,                                         ');
  Result.sql.Add('  emp.codigo_municipio as emp_codmun,                               ');
  Result.sql.Add('  emp.uf  as emp_uf,                                                ');

  Result.sql.Add('  ''2D'' as cod_mod ,                                               ');
  Result.sql.Add('  ecf.modelo_ecf as ecf_mod ,                                       ');
  Result.sql.Add('  ecf.numero_serie as ecf_fab,                                      ');
  Result.sql.Add('  case when rz0.caixa is null then 000 else rz0.caixa end as num_cx,');

  Result.sql.Add('  rz0.data_movimento as dt_doc ,                                    ');
  Result.sql.Add('  rz0.contador_reinicio as cro ,                                    ');
  Result.sql.Add('  rz0.contador_reducao as crz ,                                     ');
  Result.sql.Add('  rz0.coo_inicial as num_coo_ini,                                   ');
  Result.sql.Add('  rz0.coo_final as num_coo_fin,                                     ');
  Result.sql.Add('  rz0.grande_total as gt_fin,                                       ');
  Result.sql.Add('  rz0.venda_bruta as vl_brt ,                                       ');

  Result.sql.Add('  rz1.aliquota_trib as cod_tot_par,                                 ');
  Result.sql.Add('  rz1.totalizador as vl_acum_tot                                    ');

  Result.sql.Add('  --//11.02.2014-gonzaga, check se a redução tem movimento nestas condicoes!');
  Result.sql.Add('  ,(select count(mov.id) from pedido mov                            ');
  Result.sql.Add('    inner join pedido_itens itm on itm.idpedido  = mov.id           ');
  Result.sql.Add('    inner join item pro on pro.id_item           = itm.idproduto    ');
  Result.sql.Add('    where  mov.idempresa   =rz0.id_filial                           ');
  Result.sql.Add('    and    mov.numserieecf =rz0.seriaecf                            ');
  Result.sql.Add('    and    mov.data_pedido =rz0.data_movimento                      ');
  Result.sql.Add('    and    itm.indice_ecf is not null)as mov_count                  ');

  Result.sql.Add('from registro60m rz0                                                ');
  Result.sql.Add('inner join filial emp on emp.id_filial = rz0.id_filial              ');
  Result.sql.Add('inner join registradoras ecf on ecf.numero_serie = rz0.seriaecf     ');
  Result.sql.Add('inner join registro60a rz1 on rz1.id_reg60m = rz0.id_registro60m    ');

  if filter.CodEmp >= 1 then
  begin
    Result.sql.Add('where rz0.id_filial =%d                             ',[Self.filter.CodEmp]);
    if filter.ecf_fab <> '' then
    begin
      Result.sql.Add('and ecf.numero_serie=''%s''',[filter.ecf_fab]);
    end;
    Result.sql.Add('and   rz0.data_movimento between :dt_ini and :dt_fin');
  end
  else begin
    Result.sql.Add('where rz0.data_movimento between :dt_ini and :dt_fin');
  end;
  Result.sql.Add('and   rz1.totalizador > 0                             ');
  Result.sql.Add('order by emp_codigo, ecf_fab, dt_doc                  ');

  Result.AddParamDat('dt_ini', Self.filter.DtaIni) ;
  Result.AddParamDat('dt_fin', Self.filter.DtaFin) ;

  try
      Result.sql.SaveToFile('1.sql');
      Result.Open ;
      if Result.IsEmpty then
      begin
        fRetCod :=TLoadEFD.COD_LOAD_MOD2D_EMPTY;
        fRetMsg :='Nenhum cupom encontrado!';
      end;
  except
      on E:EDatabaseError do
      begin
        fRetCod :=TLoadEFD.COD_LOAD_ERROR;
        fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
      end;
  end;

  if fRetCod in[TLoadEFD.COD_LOAD_SUCESS, TLoadEFD.COD_LOAD_MOD2D_EMPTY] then
  begin
      femp_codigo :=Result.Field('emp_codigo');
      femp_nome   :=Result.Field('emp_nome') ;
      femp_cnpj   :=Result.Field('emp_cnpj') ;
      femp_ie     :=Result.Field('emp_ie') ;
      femp_cep    :=Result.Field('emp_cep') ;
      femp_endere :=Result.Field('emp_endere');
      femp_bairro :=Result.Field('emp_bairro');
      femp_fone   :=Result.Field('emp_fone') ;
      femp_codmun :=Result.Field('emp_codmun');
      femp_uf     :=Result.Field('emp_uf') ;

      fcod_mod  :=Result.Field('cod_mod');
      fecf_mod  :=Result.Field('ecf_mod') ;
      fecf_fab  :=Result.Field('ecf_fab') ;
      fnum_cx	  :=Result.Field('num_cx');

      fdt_doc :=Result.Field('dt_doc');
      fcro    :=Result.Field('cro') ;
      fcrz    :=Result.Field('crz');
      fnum_coo_ini  :=Result.Field('num_coo_ini');
      fnum_coo_fin  :=Result.Field('num_coo_fin');
      fgt_fin       :=Result.Field('gt_fin');
      fvl_brt       :=Result.Field('vl_brt');

      fcod_tot_par	:=Result.Field('cod_tot_par') ;
      fvl_acum_tot	:=Result.Field('vl_acum_tot') ;

      fmov_count	:=Result.Field('mov_count') ;
  end;

end;

function TLoadEFD.LoadDocFis01_C460(const cod_emp: Integer;
  const ecf_fab: string; const dt_mov: TDate): TUniQuery;
begin

    fRetCod :=0;
    fRetMsg :='';

    Result :=TUniQuery.NewQuery;
    Result.sql.Add('--/** EFD00.pas **/                                       ');
    with Result.sql do
    begin
      Add('select                                                             ');

      Add('  mov.id as id_mov ,                                               ');
      Add('  mov.numserieecf as ecf_fab ,                                     ');
      Add('  case mov.cancelado when ''S'' then 02                            ');
      Add('  else 00 end as cod_sit,                                          ');
      Add('  mov.ccf as num_doc,                                              ');
      Add('  mov.data_pedido  as dta_emi   ,                                  ');

      Add('  itm.quantidade as qtd_item,                                      ');
      Add('  itm.valor as vlr_unit,                                           ');
      Add('  itm.valor_total as vlr_tot,                                      ');

      Add('  itm.cst as cst_icms ,                                            ');
      Add('  itm.cfop as cfop ,                                               ');
      Add('  itm.base_icms as vlr_bc_icms,                                    ');
      Add('  itm.aliq_icms as aliq_icms ,                                     ');
      Add('  itm.valor_icms  as vlr_icms,                                     ');
      Add('  itm.base_icms_st as vlr_bc_icmsst,                               ');
      Add('  itm.aliq_icms_st as aliq_icmsst ,                                ');
      Add('  itm.valor_icms_st  as vlr_icmsst   ,                             ');
      Add('  case itm.cancelado when ''S'' then 1                             ');
      Add('  else 0 end as canc_item,                                         ');
      Add('  itm.indice_ecf as cod_tot,                                       ');

      Add('  pro.id_item  as cod_item     ,                                   ');
      Add('  pro.descricao  as descr_item ,                                   ');
      Add('  pro.cod_barra  as cod_barra ,                                    ');
      Add('  pro.unidade  as unid_inv ,                                       ');
      Add('  pro.ncm as cod_ncm ,                                             ');
      Add('  pro.pis as aliq_pis  ,                                           ');
      Add('  pro.cofins as aliq_cofins                                       ');

      Add('  ,case when pro.classe_pis_saida is null then 99 else pro.classe_pis_saida end as cst_pis           ');
      Add('  ,case when pro.classe_cofins_saida is null then 99 else pro.classe_cofins_saida end as cst_cofins  ');

      Add('  ,%d as cod_gen                                                     ', [TDefValue.COD_GEN_ITEM]);

      Add('from pedido mov                                                    ');
      Add('inner join pedido_itens itm on itm.idpedido = mov.id               ');
      Add('left join item pro on pro.id_item           = itm.idproduto        ');

      Add('where  mov.idempresa =:cod_emp                                     ');
      Add('and    mov.numserieecf =:ecf_fab                                   ');
      Add('and    mov.data_pedido =:dt_mov                                    ');
      Add('and    itm.indice_ecf is not null                                  ');
      Add('and    itm.idproduto > 0                                           ');

//      if filter.CodEmp >= 1 then
//      begin
//        Add('where  mov.idempresa =%d                                           ',[Self.filter.CodEmp]);
//        Add('and    mov.data_pedido between :dt_ini and :dt_fin               ');
//      end
//      else begin
//        Add('where  mov.data_pedido between :dt_ini and :dt_fin               ');
//      end;
      Add('order by mov.idempresa, mov.id, itm.idproduto                      ');

    end;

    try
        Result.AddParamInt('cod_emp', cod_emp     );
        Result.AddParamStr('ecf_fab', ecf_fab, 20 );
        Result.AddParamDat('dt_mov' , dt_mov      );

//        Result.AddParamDat('dt_ini', Self.filter.DtaIni) ;
//        Result.AddParamDat('dt_fin', Self.filter.DtaFin) ;

        Result.Open ;
        if Result.IsEmpty then
        begin
            fRetCod :=-1;
            fRetMsg :='Nenhum registro encontrado!';
        end;
    except
        on E:EDatabaseError do
        begin
            fRetCod :=-1;
            fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
        end;
    end;

    if fRetCod=0 then
    try
//        fecf_fab	:=Result.Field('ecf_fab') ;
        fid_mov	:=Result.Field('id_mov') ;
        fcod_sit	:=Result.Field('cod_sit') ;
        fnum_doc	:=Result.Field('num_doc') ;
        fdta_emi	:=Result.Field('dta_emi') ;

//        find_emit	:=Result.Field('ind_emit');
//        find_oper	:=Result.Field('ind_oper');
//        fser_doc	:=Result.Field('ser_doc');
//        fchv_nfe	:=Result.Field('chv_nfe') ;
//        fpart_cod	:=Result.Field('part_cod') ;

//        fvlr_out_da:=Result.Field('vlr_out_da');
//        fvlr_desc  :=Result.Field('vlr_desc');
        fqtd_item  :=Result.Field('qtd_item');
        fvlr_unit  :=Result.Field('vlr_unit');
        fvlr_item  :=Result.Field('vlr_tot');
        fvlr_tot   :=Result.Field('vlr_tot');

        fcst_icms  :=Result.Field('cst_icms');
        fcfop   	 :=Result.Field('cfop') ;
        faliq_icms :=Result.Field('aliq_icms');
        fvlr_bc_icms:=Result.Field('vlr_bc_icms');
        fvlr_icms		:=Result.Field('vlr_icms') ;
        fvlr_bc_icmsst:=Result.Field('vlr_bc_icmsst');
        fvlr_icmsst   :=Result.Field('vlr_icmsst') ;

//        fvlr_rbc      :=Result.Field('vlr_rbc') ;

        fcod_item :=Result.Field('cod_item');
        fdescr_item :=Result.Field('descr_item');
        fcod_barra :=Result.Field('cod_barra');
        funid_inv :=Result.Field('unid_inv');
        fcod_ncm :=Result.Field('cod_ncm');
        fcod_gen :=Result.Field('cod_gen');
        faliq_pis :=Result.Field('aliq_pis');
        faliq_cofins :=Result.Field('aliq_cofins');

        fcst_pis :=Result.Field('cst_pis');
        fcst_cofins :=Result.Field('cst_cofins');

        fcanc_item :=Result.Field('canc_item');
        fcod_tot :=Result.Field('cod_tot');
    except
        on E:Exception do
        begin
            fRetCod :=-1;
            fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
        end;
    end;

end;

function TLoadEFD.LoadDocFis02: {$IFDEF ZEOS } TQueryDBZ; {$ELSE} TUniQuery ; {$ENDIF} // ICMS/SERVIÇOS
begin

    Result :=nil;
    fRetCod :=0;
    fRetMsg :='';

{    if not TMetaData.ObjExists('estfrt00','') then
    begin
      fRetCod :=-3;
      fRetMsg :='Nome de objeto "estfrt00" inválido!';
      Exit;
    end;

    Result :=NewQueryDBZ(CDataBase);
    with Result.sql do
    begin
        Add('declare @codfil smallint; set @codfil=%d ',[filter.CodEmp]);
        Add('declare @dtaini datetime; set @dtaini=%s ',[Result.SQLFun.SDatSQL(filter.DtaIni)]);
        Add('declare @dtafin datetime; set @dtafin=%s ',[Result.SQLFun.SDatSQL(filter.DtaFin,True)]);
        //
        Add('select                                                      ');
        Add('  fil00_codigo as emp_codigo,                               ');
        Add('  fil00_cgc    as emp_cnpj ,                                ');
        Add('  for00_codigo as part_cod     ,                            ');
        Add('  for00_descri as part_nome    ,                            ');
        Add('  for00_fj     as part_typpes  ,                            ');
        Add('  case when for00_fj=''F'' then for00_cic end  as part_cpf ,');
        Add('  case when for00_fj=''J'' then for00_cic end  as part_cnpj,');
        Add('  for00_insest as part_ie      ,                            ');
        Add('  for00_ende   as part_endere  ,                            ');
        Add('  for00_bairro as part_bairro  ,                            ');
        Add('  cid00_ibgecod as part_codmun ,                            ');
        Add('  frt00_modntf as cod_mod,                                  ');
        Add('  frt00_serntf as ser_doc,                                  ');
        Add('  frt00_subntf as sub_ser,                                  ');
        Add('  frt00_nconhe as num_doc,                                  ');
        Add('  frt00_datemi as dta_emi,                                  ');
        Add('  frt00_vlrfrt as vlr_tot,                                  ');
        Add('  frt00_vlrbas as vlr_bc_icms,                              ');
        Add('  frt00_vlricm as vlr_icms,                                 ');
        Add('  frt00_cfop as cfop,                                       ');
        Add('  frt00_alqfrt as aliq_icms                                 ');
        Add('from estfrt00(nolock)																	     ');
        Add('inner join cadfil00(nolock) on fil00_codigo =frt00_codfil   ');
        Add('left join cadfor00(nolock) on for00_codigo  =frt00_codfor   ');
        Add('left join cadcid00 (nolock) on cid00_codigo =for00_codcid   ');
        if filter.CodEmp >= 1 then
        begin
            Add('where frt00_codfil =@codfil                                 ');
            Add('and   frt00_datemi between @dtaini and @dtafin              ');
        end
        else begin
            Add('where frt00_datemi between @dtaini and @dtafin              ');
        end;
        Add('order by emp_codigo, num_doc                                    ');
    end;

    try
        //Result.sql.SaveToFile('0.sql');
        Result.Open ;
        if Result.IsEmpty then
        begin
            fRetCod :=-2;
            fRetMsg :='Nenhum doc fiscais II encontrado!';
        end;
    except
        on E:EDatabaseError do
        begin
            fRetCod :=-2;
            fRetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
        end;
    end;

    if fRetCod=0 then
    begin
        femp_codigo :=Result.Field('emp_codigo');
        femp_cnpj   :=Result.Field('emp_cnpj') ;

        fpart_cod	  :=Result.Field('part_cod');
        fpart_nome  :=Result.Field('part_nome');
        fpart_cpf   :=Result.Field('part_cpf') ;
        fpart_cnpj  :=Result.Field('part_cnpj');
        fpart_ie    :=Result.Field('part_ie');
        fpart_endere:=Result.Field('part_endere');
        fpart_bairro:=Result.Field('part_bairro');
        fpart_codmun:=Result.Field('part_codmun');

        fcod_mod	:=Result.Field('cod_mod') ;
        fser_doc	:=Result.Field('ser_doc') ;
        fsub_ser  :=Result.Field('sub_ser') ;
        fnum_doc	:=Result.Field('num_doc') ;
        fdta_emi	:=Result.Field('dta_emi') ;
        fvlr_tot  :=Result.Field('vlr_tot') ;
        fvlr_bc_icms:=Result.Field('vlr_bc_icms') ;
        fvlr_icms		:=Result.Field('vlr_icms') ;
        fcfop		:=Result.Field('cfop') ;
        faliq_icms		:=Result.Field('aliq_icms') ;
    end;}
end;

function TLoadEFD.LoadEmpresa(const codfil: Integer): TUniQuery;
begin
  Result :=TUniQuery.NewQuery();

  Result.sql.Add('select id_filial as emp_codigo,   ');
  Result.sql.Add('  nome  as emp_nome   ,           ');
  Result.sql.Add('  cnpj   as emp_cnpj  ,           ');
  Result.sql.Add('  ie  as emp_ie    ,              ');
  Result.sql.Add('  cep     as emp_cep   ,          ');
  Result.sql.Add('  tipo_logradouro as emp_logr,    ');
  Result.sql.Add('  logradouro    as emp_endere,    ');
  Result.sql.Add('  numero    as emp_numero,        ');
  Result.sql.Add('  bairro  as emp_bairro,          ');
  Result.sql.Add('  tel    as emp_fone  ,           ');
  Result.sql.Add('  codigo_municipio as emp_codmun, ');
  Result.sql.Add('  uf  as emp_uf                   ');
  Result.sql.Add('from filial                       ');
  Result.sql.Add('where id_filial=:id_filial        ');
  Result.sql.Add('order by id_filial                ');

  Result.AddParamInt('id', codfil) ;

  Result.Open ;
  femp_codigo :=Result.Field('emp_codigo');
  femp_nome   :=Result.Field('emp_nome  ');
  femp_cnpj   :=Result.Field('emp_cnpj  ');
  femp_ie     :=Result.Field('emp_ie'    );
  femp_cep    :=Result.Field('emp_cep   ');
  femp_logr   :=Result.Field('emp_logr  ');
  femp_endere :=Result.Field('emp_endere');
  femp_numero :=Result.Field('emp_numero');
  femp_bairro :=Result.Field('emp_bairro');
  femp_codmun :=Result.Field('emp_codmun');
  femp_uf     :=Result.Field('emp_uf    ');
  femp_fone   :=Result.Field('emp_fone  ');
end;

procedure TLoadEFD.SetVars(const AReg_C400: Boolean) ;
var
  tip_item: TItemTyp;
begin

  id_mov  :=fid_mov.AsInteger;
  cod_sit :=TCodSitDoc(fcod_sit.AsInteger) ;
  num_doc :=fnum_doc.AsInteger;
  qtd_item :=fqtd_item.AsCurrency;
  vlr_unit :=fvlr_unit.AsCurrency;

  if AReg_C400 then
  begin
    vlr_item :=fvlr_item.AsCurrency;
    vbc_icms :=vlr_item;
  end
  else begin
    ind_ope :=TIndTypOper(find_oper.AsInteger);
    ind_emi :=TIndEmiDoc(find_emit.AsInteger);
    chv_nfe :=Trim(fchv_nfe.AsString) ;
    cod_mod :=Tefd_util.FInt(fcod_mod.AsInteger, 2);
    ser_doc :=Tefd_util.FInt(fser_doc.AsInteger, 3);
    part_cod :='';
    if fpart_cod.AsInteger > 0 then
    begin
      part_cod :=IfThen(ind_emi = emiTerc,'F','C') +Tefd_util.FInt(fpart_cod.AsInteger, 6);
    end;
    part_nome:=Trim(fpart_nome.AsString);
    part_cnpj:=Tefd_util.GetNumbers(fpart_cnpj.AsString);
    part_cpf :=Tefd_util.GetNumbers(fpart_cpf.AsString) ;
    part_ie  :=Tefd_util.GetNumbers(fpart_ie.AsString) ;
    part_endere:=Trim(fpart_endere.AsString) ;
    part_bairro:=Trim(fpart_bairro.AsString) ;
    part_codmun:=fpart_codmun.AsInteger;

    if ind_ope = toEnt then
    begin
      if Length(chv_nfe)=44 then
      begin
        if(chv_nfe[21]='5')and(chv_nfe[22]='5')then
        begin
          cod_mod :='55';
          num_doc :=StrToIntDef(Copy(chv_nfe, 26, 9), 0);
        end
        else begin
          cod_mod :='01';
          chv_nfe :='';
        end;
      end
      else begin
        cod_mod :='01';
        chv_nfe :='';
      end;
    end;

    vlr_item :=qtd_item *vlr_unit;
    vbc_icms :=fvlr_bc_icms.AsCurrency;
    aliq_rbc :=faliq_rbc.AsCurrency ;
  end;

  cod_item :=fcod_item.AsString ;
  cod_barra :=fcod_barra.AsString  ;
  descr_item :=fdescr_item.AsString;
  und_item :=funid_inv.AsString ;
  tip_item :=itmRevenda;
  cod_ncm :=fcod_ncm.AsString ;
  cod_gen :=fcod_gen.AsInteger;

  cst_icms :=fcst_icms.AsInteger;
  cfop     :=fcfop.AsInteger;
  aliq_icms:=faliq_icms.AsCurrency;

  if cod_sit = csDocRegular then
  begin

    if ind_ope = toEnt then
    begin
      case cfop of
        5101,5102: cfop :=1102 ;
        1405,5403,5405: cfop :=1403 ;
        6403: cfop :=2403 ;
      else
        if IntToStr(cfop)[1] = '5' then
        begin
          cfop :=1102;
        end
        else if IntToStr(cfop)[1] = '6' then
        begin
          cfop :=2102;
        end;
      end;
    end;

    // Transferência de material de uso ou consumo
    if cfop=5557 then
    begin
      tip_item :=itmMatCons;
    end ;

    if Tefd_util.CFOP_IsST(cfop) then
    begin
      cst_icms :=60;
    end ;

    if cst_icms in[30,40,41,50,60] then
    begin
      aliq_icms :=0;
      vbc_icms  :=0;
    end;

    vlr_icms :=vbc_icms * (aliq_icms /100);

{

                if ind_emi=emiTerc then
                begin
                    // itens (produtos e serviços)
                    und_item :=funid_inv.AsString ;
                    EFD_Fiscal.Bloco_0.NewReg_0200(cod_item  ,
                                                   fdescr_item.AsString ,
                                                   fcod_barra.AsString  ,
                                                   und_item  ,
                                                   itmRevenda ,
                                                   fcod_ncm.AsString  ,
                                                   fcod_gen.AsInteger);
                    if cod_item = 0 then
                    begin
                      AddLog('  REGISTRO 0200: Código do Item [%s] inválido! Id_Mov:%d',[fdescr_item.AsString,id_mov]);
                    end ;
                    if fdescr_item.AsString = '' then
                    begin
                      AddLog('  REGISTRO 0200: Descrição do Item [%d] inválido! Id_Mov:%d',[cod_item,id_mov]);
                    end ;
                end;
}

    if EFD is TEFD_Fiscal then
    begin

      if cst_icms = 60 then
      begin
        cfop :=5405 ;
      end;

      //Não ah participantes para o REGISTRO C400
      if not AReg_C400 then
      begin
        TEFD_Fiscal(EFD).Bloco_0.NewReg_0150(part_cod,
                                            part_nome ,
                                            part_cnpj ,
                                            part_cpf ,
                                            part_ie ,
                                            part_endere, '',
                                            part_bairro,
                                            part_codmun);
        if part_cod = '' then
        begin
          TSWLog.Add('  REGISTRO 0150: Código do participante [%s] inválido! Id_Mov:%d!',[part_nome,id_mov]);
        end ;
        if part_nome = '' then
        begin
          TSWLog.Add('  REGISTRO 0150: Nome do participante [%s] inválido! Id_Mov:%d!',[part_cod,id_mov]);
        end ;
      end;

      if ind_emi=emiTerc then
      begin
        TEFD_Fiscal(EFD).Bloco_0.NewReg_0200(cod_item  ,
                                       descr_item ,
                                       cod_barra  ,
                                       und_item  ,
                                       tip_item ,
                                       cod_ncm, cod_gen);
        if cod_item = '' then
        begin
          TSWLog.Add('  REGISTRO 0200: Código do Item [%s] inválido! Id_Mov:%d',[fdescr_item.AsString,id_mov]);
        end ;
        if fdescr_item.AsString = '' then
        begin
          TSWLog.Add('  REGISTRO 0200: Descrição do Item [%d] inválido! Id_Mov:%d',[cod_item,id_mov]);
        end ;
      end;
    end

    else if EFD is TEFD_Contrib then
    begin
      //Não ah participantes para o REGISTRO C400
      if not AReg_C400 then
      begin
        TEFD_Contrib(EFD).Bloco_0.NewReg_0150(part_cod,
                                            part_nome ,
                                            part_cnpj ,
                                            part_cpf ,
                                            part_ie ,
                                            part_endere, '',
                                            part_bairro,
                                            part_codmun);
        if part_cod = '' then
        begin
          TSWLog.Add('  REGISTRO 0150: Código do participante [%s] inválido! Id_Mov:%d!',[part_nome,id_mov]);
        end ;
        if part_nome = '' then
        begin
          TSWLog.Add('  REGISTRO 0150: Nome do participante [%s] inválido! Id_Mov:%d!',[part_cod,id_mov]);
        end ;
      end;
      TEFD_Contrib(EFD).Bloco_0.NewReg_0200(cod_item  ,
                                           descr_item ,
                                           cod_barra  ,
                                           und_item  ,
                                           tip_item ,
                                           cod_ncm, cod_gen);
    end;

  end;

end;

{ TSpedFiscal }

constructor TSpedFiscal.Create;
begin
  inherited Create;
  EFD_Fiscal :=TEFD_Fiscal.Create ;
  EFD :=EFD_Fiscal ;
  ForceRegC170 :=False;
  //AddLog('Iniciou objeto EFD-ICMS/IPI');
  AddLog('Iniciou objeto %s',[Self.ClassName]);
end;

destructor TSpedFiscal.Destroy;
begin
  EFD :=nil;
  EFD_Fiscal.Destroy;
  inherited Destroy ;
  AddLog('Finalizou objeto TSpedFiscal');
end;

procedure TSpedFiscal.DoFillBD;
var
    Q: TUniQuery;
var
    r_D100: ufisbloco_D.Tregistro_D100 ;
    r_D190: ufisbloco_D.Tregistro_D190 ;

var
    ind_ope: TIndTypOperD;
    ind_emi: TIndEmiDoc;
    num_doc: Integer ;
    cod_mod: string;
    ser_doc: String;
    sub_ser: String;
    cod_par: string;
var
    cst_icms: Word ;
    cfop: Word;
    aliq_icms: Currency ;

begin

    Q := inherited LoadDocFis02;
    try
        if(Q = nil) or(fRetCod<>0) then
        begin
            Exit;
        end;

        while not Q.Eof do
        begin

            cod_par :='F' +Tefd_util.FInt(fpart_cod.AsInteger, 6);
            EFD_Fiscal.Bloco_0.NewReg_0150(cod_par ,
                                           fpart_nome.AsString  ,
                                           Tefd_util.GetNumbers(fpart_cnpj.AsString) ,
                                           Tefd_util.GetNumbers(fpart_cpf.AsString)  ,
                                           Tefd_util.GetNumbers(fpart_ie.AsString) ,
                                           fpart_endere.AsString , '',
                                           fpart_bairro.AsString ,
                                           fpart_codmun.AsInteger);

            ind_ope:=toAquis ;
            ind_emi:=emiProp ;
            num_doc:=fnum_doc.AsInteger;
            cod_mod:=Tefd_util.FInt(fcod_mod.AsInteger,2) ;
            ser_doc:=fser_doc.AsString;
            sub_ser:=fsub_ser.AsString;

            r_D100 :=EFD_Fiscal.Bloco_D.NewReg_D100(ind_emi,
                                                    num_doc,
                                                    cod_mod,
                                                    ser_doc,
                                                    sub_ser,
                                                    cod_par);
            if r_D100.Status =rsNew then
            begin
                r_D100.ind_oper:=ind_ope ;
                r_D100.cod_sit :=csDocRegular ;
                r_D100.dta_doc :=fdta_emi.AsDateTime;
                r_D100.vl_doc :=fvlr_tot.AsCurrency;
                r_D100.ind_fret:=tfDest;
                r_D100.vl_serv:=fvlr_tot.AsCurrency;
            end;

            cst_icms:=90 ;
            cfop    :=fcfop.AsInteger;
            aliq_icms:=faliq_icms.AsCurrency;

            r_D190 :=r_D100.registro_D190.IndexOf(cst_icms, cfop, aliq_icms) ;
            if r_D190 = nil then
            begin
                r_D190 :=r_D100.registro_D190.AddNew ;
                r_D190.cst_icms :=cst_icms ;
                r_D190.cfop     :=cfop;
                r_D190.aliq_icms:=faliq_icms.AsCurrency ;
                r_D190.vl_oper :=fvlr_tot.AsCurrency ;
                r_D190.vl_bc_icms :=fvlr_bc_icms.AsCurrency;
                r_D190.vl_icms :=fvlr_icms.AsCurrency ;
            end
            else
            begin
                r_D190.vl_oper    :=r_D190.vl_oper    +fvlr_tot.AsCurrency ;
                r_D190.vl_bc_icms :=r_D190.vl_bc_icms +fvlr_bc_icms.AsCurrency;
                r_D190.vl_icms    :=r_D190.vl_icms    +fvlr_icms.AsCurrency ;
            end ;

            Q.Next;
        end;

    finally
      	if Assigned(Q) then Q.Free ;
    end;

end;

procedure TSpedFiscal.DoFillEFD;
var
  Q: TUniQuery ;
var
  r_C100: ufisbloco_C.Tregistro_C100;
  r_C170: EFDCommon.Tregistro_C170;   // ufisbloco_C.Tregistro_C170;
  r_C190: ufisbloco_C.Tregistro_C190;

var
  ind_ope: TIndTypOper;
  ind_emi: TIndEmiDoc ;
  cod_sit: TCodSitDoc ;
  cod_par: string ;
  cod_mod: string ;
  ser_doc: string ;
  num_doc: Integer;
  inc_fret:Boolean;
  chv_nfe: string;
var
  cod_item: Integer;
  und_item: string;
  vlr_item: Currency;
  vlr_fret: Currency;
  vlr_desc: Currency;
  vlr_out_da: Currency;
  cst_icms: Word;
  cfop: Word;

  vbc_icms,
  aliq_icms,
  vlr_icms:Currency;
  vlr_rbc: Currency;
  vlr_icmsst: Currency;
  vlr_ipi: Currency;

var //PIS/COFINS
  cst_pis:Word;
  aliq_pis:Currency;
  cst_cofins:Word ;
  aliq_cofins:Currency;
  cls_fis:Byte ;
  vlr_tot:Currency;
  nat_oper: Word ;

var
  codmun: Integer ;

begin
  //
  Stop :=False;

  AddLog('Carregando notas fiscais modelo (01/55/65) de %s',[FormatDateTime('mmm/yyyy', filter.DtaFin)]);
  Q :=inherited LoadDocFis01;
  try
    while not Q.Eof do
    begin

        if Stop then
        begin
          Break;
        end;

        id_mov :=fid_mov.AsInteger;
        ind_emi :=TIndEmiDoc(find_emit.AsInteger);
        cod_sit :=TCodSitDoc(fcod_sit.AsInteger) ;
        cod_par :=IfThen(ind_emi=emiTerc,'F','C') +Tefd_util.FInt(fpart_cod.AsInteger, 6);
        cod_item:=fcod_item.AsInteger ;

        // somente os doc´s.cuja situacao estao regular
        if cod_sit=csDocRegular then
        begin
            // participantes
            EFD_Fiscal.Bloco_0.NewReg_0150(cod_par,
                                           fpart_nome.AsString ,
                                           Tefd_util.GetNumbers(fpart_cnpj.AsString) ,
                                           Tefd_util.GetNumbers(fpart_cpf.AsString) ,
                                           Tefd_util.GetNumbers(fpart_ie.AsString) ,
                                           fpart_endere.AsString, '',
                                           fpart_bairro.AsString,
                                           fpart_codmun.AsInteger);
            if cod_par = '' then
            begin
              AddLog('  REGISTRO 0150: Código do participante [%s] inválido! Id_Mov:%d',[fpart_nome.AsString,id_mov]);
            end ;
            if fpart_nome.AsString = '' then
            begin
              AddLog('  REGISTRO 0150: Nome do participante [%s] inválido! Id_Mov:%d',[cod_par,id_mov]);
            end ;

            if ind_emi=emiTerc then
            begin
                // itens (produtos e serviços)
                und_item :=funid_inv.AsString ;
                EFD_Fiscal.Bloco_0.NewReg_0200(IntToStr(cod_item)  ,
                                               fdescr_item.AsString ,
                                               fcod_barra.AsString  ,
                                               und_item  ,
                                               itmRevenda ,
                                               fcod_ncm.AsString  ,
                                               fcod_gen.AsInteger);
                if cod_item = 0 then
                begin
                  AddLog('  REGISTRO 0200: Código do Item [%s] inválido! Id_Mov:%d',[fdescr_item.AsString,id_mov]);
                end ;
                if fdescr_item.AsString = '' then
                begin
                  AddLog('  REGISTRO 0200: Descrição do Item [%d] inválido! Id_Mov:%d',[cod_item,id_mov]);
                end ;
            end;
        end;

        ind_ope :=TIndTypOper(find_oper.AsInteger);
        chv_nfe :=Trim(fchv_nfe.AsString) ;
        cod_mod :=Tefd_util.FInt(fcod_mod.AsInteger, 2);
        ser_doc :=Tefd_util.FInt(fser_doc.AsInteger, 3);
        num_doc :=fnum_doc.AsInteger;

        get_InfoDoc(ind_ope, chv_nfe, cod_mod, num_doc, ser_doc);

        inc_fret :=False ;// LowerCase(finc_fret.AsString)='t';

        vlr_fret :=fvlr_fret.AsCurrency ;
        vlr_desc :=fvlr_desc.AsCurrency ;
        vlr_out_da :=fvlr_out_da.AsCurrency ;

        // doc´s entradas/saidas
        r_C100 :=EFD_Fiscal.Bloco_C.NewReg_C100(ind_ope,
                                                ind_emi,
                                                cod_par,
                                                cod_mod,
                                                ser_doc,
                                                cod_sit,
                                                num_doc);
        if r_C100.Status = rsNew then
        begin
            r_C100.chv_nfe :=chv_nfe ;
            r_C100.dta_emi :=fdta_emi.AsDateTime;
            r_C100.dta_e_s :=fdta_e_s.AsDateTime;
            r_C100.ind_pgto:=tpOut ;
            r_C100.ind_fret:=TIndTypFret(find_fret.AsInteger);
            r_C100.vl_fret :=vlr_fret; //fvlr_fret.AsCurrency;
            r_C100.vl_out_da:=0;//vlr_out_da; //fvlr_out_da.AsCurrency;
            r_C100.vl_desc  :=vlr_desc; //fvlr_desc.AsCurrency;
        end;

        // itens somente para doc regular
        if r_C100.cod_sit=csDocRegular then
        begin
            cfop     :=fcfop.AsInteger;

            if r_C100.ind_oper = toEnt then
            begin
              case cfop of
                5101,5102: cfop :=1102 ;
                1405,5403,5405: cfop :=1403 ;
                6403: cfop :=2403 ;
              else
                if IntToStr(cfop)[1] = '5' then
                begin
                  cfop :=1102;
                end
                else if IntToStr(cfop)[1] = '6' then
                begin
                  cfop :=2102;
                end;
              end;
            end;

            vlr_item :=fqtd_item.AsCurrency *fvlr_unit.AsCurrency;
            vbc_icms :=fvlr_bc_icms.AsCurrency;
            aliq_icms:=faliq_icms.AsCurrency;
            vlr_icms :=fvlr_icms.AsCurrency;

            vlr_rbc  :=fvlr_rbc.AsCurrency ;
            vlr_icmsst :=fvlr_icmsst.AsCurrency;
            vlr_ipi  :=fvlr_ipi.AsCurrency ;
            aliq_rbc :=faliq_rbc.AsCurrency ;

            if inc_fret then
            begin
                vbc_icms :=vbc_icms +fvlr_bc_fret.AsCurrency ;
                vlr_icms :=vlr_icms +fvlr_icmsfret.AsCurrency;
            end;

            // inicializa CST ICMS
            if vlr_rbc>0 then
            begin
                cst_icms :=20;
            end
            else
              if Tefd_util.CFOP_IsST(cfop) then
              begin
                cst_icms :=60;
              end
              else begin
                if fcst_icms.IsNull or (fcst_icms.AsString='') then
                  cst_icms :=0
                else
                  cst_icms :=fcst_icms.AsInteger;
              end;

            if cst_icms in[20,70] then
            begin
              vlr_rbc :=((100 -aliq_rbc)* vlr_item)/100 ;
            end;

            //13.10.2012 - zera ICMS para todas as cfop´s q estão em
            //1551,2551,1556,2556,1949,2949,1557,1403,2403,5403
            //e repassa para valor nao trib (vl_red_bc)
            if Tefd_util.CFOP_In(cfop,[1551,2551,1556,2556,1949,2949,1557])or
              Tefd_util.CFOP_IsST(cfop) then
            begin
                vlr_rbc  :=vlr_rbc +vbc_icms;
                vbc_icms :=0;
                aliq_icms:=0;
                vlr_icms :=0;
            end;

            //09.11.2012-cfop 6403 zerar ICMS somente nas saidas
            if (ind_ope=toSai)and(cfop=6403) then
            begin
                vbc_icms :=0;
                aliq_icms:=0;
                vlr_icms :=0;
            end;

            if not(r_C100.ind_emit=emiProp) then
            begin
                r_C100.ind_pgto :=tpAprz;
            end ;

            if r_C100.ind_emit=emiTerc then
            begin

                r_C170 :=r_C100.registro_C170.AddNew;
                r_C170.nro_item 	 :=r_C100.registro_C170.Count;
                r_C170.cod_item 	 :=fcod_item.AsString	;
                r_C170.descr_compl :=fdescr_item.AsString	;
                r_C170.qtd_item	   :=fqtd_item.AsCurrency	;
                r_C170.und_item	   :=und_item ;
                r_C170.vl_item	   :=vlr_item ;
                r_C170.vl_desc     :=vlr_desc; //fvlr_desc.AsCurrency;
                if inc_fret then
                begin
                    r_C170.vl_fret :=vlr_fret; //fvlr_fret.AsCurrency;
                end;
                r_C170.vl_out_da   :=0; //vlr_out_da; //fvlr_out_da.AsCurrency;
                r_C170.ind_mov	   :=movFis;
                r_C170.cst_icms	   :=cst_icms;
                r_C170.cfop			   :=cfop;
                r_C170.cod_nat	   :='';
                r_C170.vl_bc_icms  :=vbc_icms;
                r_C170.aliq_icms	 :=aliq_icms;
                r_C170.vl_icms     :=vlr_icms;
                r_C170.vl_bc_icmsst:=fvlr_bc_icmsst.AsCurrency;
                r_C170.vl_icmsst   :=vlr_icmsst;
                r_C170.vl_bc_ipi:=vbc_icms;
                r_C170.aliq_ipi	:=faliq_ipi.AsCurrency;
                r_C170.vl_ipi   :=vlr_ipi;

                if r_C100.ind_oper=toEnt then r_C170.cod_cta :=Self.CodCta_Ent
                else                          r_C170.cod_cta :=Self.CodCta_Sai;

            end;

            r_C190 :=r_C100.registro_C190.IndexOf(cst_icms, cfop, aliq_icms);
            if r_C190 = nil then
            begin
                r_C190 :=r_C100.registro_C190.AddNew;
                r_C190.cst_icms  :=cst_icms;
                r_C190.cfop		   :=cfop;
                r_C190.per_icms  :=aliq_icms;
                r_C190.vl_oper :=(vlr_item -vlr_desc) +vlr_out_da +vlr_icmsst +vlr_ipi;

                if inc_fret then
                begin
                    r_C190.vl_oper :=r_C190.vl_oper +vlr_fret;
                end;

                r_C190.vl_bc_icms    :=vbc_icms;
                r_C190.vl_icms       :=vlr_icms;
                r_C190.vl_bc_icms_st :=fvlr_bc_icmsst.AsCurrency;
                r_C190.vl_icms_st    :=vlr_icmsst;
                r_C190.vl_rbc        :=vlr_rbc;
                r_C190.vl_ipi        :=vlr_ipi;
            end
            else begin
                r_C190.vl_oper :=r_C190.vl_oper +(vlr_item -vlr_desc) ;
                if inc_fret then
                begin
                    r_C190.vl_oper :=r_C190.vl_oper +vlr_fret;
                end;
                r_C190.vl_oper := r_C190.vl_oper +
                                  vlr_out_da+
                                  vlr_icmsst+
                                  vlr_ipi;

                r_C190.vl_bc_icms		:=r_C190.vl_bc_icms 		+vbc_icms;
                r_C190.vl_icms			:=r_C190.vl_icms				+vlr_icms;
                r_C190.vl_bc_icms_st:=r_C190.vl_bc_icms_st	+fvlr_bc_icmsst.AsCurrency;
                r_C190.vl_icms_st		:=r_C190.vl_icms_st		+vlr_icmsst;
                r_C190.vl_rbc				:=r_C190.vl_rbc				+vlr_rbc;
                r_C190.vl_ipi				:=r_C190.vl_ipi				+vlr_ipi;
            end;
        end;

        Q.Next;
    end;

  finally
    AddLog('%d notas fiscais encontradas.',[Q.RecordCount]);
    Q.Destroy ;
  end;
end;

procedure TSpedFiscal.DoFillEFD_C100FromFile(const AFileName: string;
  const EmiDoc: TIndEmiDoc);
var
  r_0190: Tregistro_0190;
  r_C100: ufisbloco_C.Tregistro_C100;
  r_C170: EFDCommon.Tregistro_C170;   // ufisbloco_C.Tregistro_C170;
  r_C190: ufisbloco_C.Tregistro_C190;
var
  nfe: TNFe ;
  det: TnfeDet;
var
  I: Integer ;
  L,S,R,V: string;
var
//  ind_ope: TIndTypOper;
//  ind_emi: TIndEmiDoc ;
//  cod_sit: TCodSitDoc ;
  cod_par: string ;
  chv_nfe: string;
  ind_fret:TIndTypFret;
//  cod_mod: string ;
//  ser_doc: string ;
//  num_doc: Integer;
//  inc_fret:Boolean;
//  chv_nfe: string;
//var
//  cod_item: Integer;
//  und_item: string;
//  vlr_item: Currency;
//  vlr_fret: Currency;
//  vlr_desc: Currency;
//  vlr_out_da: Currency;
//  cst_icms: Word;
//  cfop: Word;
//
//  vbc_icms,
//  aliq_icms,
//  vlr_icms:Currency;
//  vlr_rbc: Currency;
//  vlr_icmsst: Currency;
//  vlr_ipi: Currency;

begin

  if not FileExists(AFileName) then
  begin
    Exit
    ;
  end;
  AddLog('Importando NFe: %s',[AFileName]);

  nfe :=TNFe.Create ;
  try
    nfe.LoadFromFile(AFileName, S);

    id_mov :=1;
    ind_emi :=EmiDoc;
    cod_sit :=csDocRegular ;
    if ind_emi = emiProp then
    begin
      ind_ope :=toSai ;
      cod_par :=nfe.dest.CNPJ;
      if cod_par = '' then
      begin
          cod_par :=nfe.dest.CPF;
      end;
    end
    else begin
      ind_ope :=toEnt ;
      nfe.ide.dSaiEnt :=nfe.ide.dEmi ;
      cod_par :=nfe.emit.CNPJ;
    end;

    ind_fret:=tfDest;
    chv_nfe :=nfe.Id ;
    cod_mod :=Copy(chv_nfe,21,2);
    if chv_nfe <> '' then
    begin
      if cod_mod = '65' then
      begin
        ind_fret:=tfNone ;
      end;
    end
    else begin
      cod_mod :='55';
    end;

    ser_doc :=Tefd_util.FInt(nfe.ide.serie, 3, '000');
    num_doc :=nfe.ide.nNF;

    //get_InfoDoc(ind_ope, chv_nfe, cod_mod, num_doc);

    // somente os doc´s.cuja situacao estao regular
    if cod_sit=csDocRegular then
    begin
        // participantes
        if ind_emi = emiProp then
        begin
          if cod_mod = '55' then
          begin
            nfe.dest.ender.xLgr :=StringReplace(nfe.dest.ender.xLgr, '|', ',', [rfReplaceAll]);
            EFD_Fiscal.Bloco_0.NewReg_0150(cod_par,
                                           nfe.dest.xNome ,
                                           nfe.dest.CNPJ ,
                                           nfe.dest.CPF ,
                                           nfe.dest.IE ,
                                           nfe.dest.ender.xLgr,
                                           nfe.dest.ender.xCpl,
                                           nfe.dest.ender.xBairro,
                                           nfe.dest.ender.cMun);
          end;
        end
        else begin
          EFD_Fiscal.Bloco_0.NewReg_0150(cod_par,
                                         nfe.emit.xNome, // nfe.dest.xNome ,
                                         nfe.emit.CNPJ, //nfe.dest.CNPJ ,
                                         '', //nfe.dest.CPF ,
                                         nfe.emit.IE, // nfe.dest.IE ,
                                         nfe.emit.ender.xLgr, // nfe.dest.ender.xLgr,
                                         nfe.emit.ender.xCpl, // nfe.dest.ender.xCpl,
                                         nfe.emit.ender.xBairro, // nfe.dest.ender.xBairro,
                                         nfe.emit.ender.cMun // nfe.dest.ender.cMun
                                         );
        end;
    end;

    // doc´s entrada/saida
    r_C100 :=EFD_Fiscal.Bloco_C.NewReg_C100(ind_ope,
                                            ind_emi,
                                            cod_par,
                                            cod_mod,
                                            ser_doc,
                                            cod_sit,
                                            num_doc);
    r_C100.chv_nfe :=chv_nfe ;
    r_C100.dta_emi :=nfe.ide.dEmi;
    r_C100.dta_e_s :=nfe.ide.dSaiEnt;
    r_C100.ind_pgto:=tpOut ;
    r_C100.ind_fret:=ind_fret;
    r_C100.vl_fret :=nfe.total.vFrete;
    r_C100.vl_out_da:=nfe.total.vOutro;
    r_C100.vl_desc  :=nfe.total.vDesc;

    for I :=0 to nfe.det.Count -1 do
    begin
      det :=nfe.det.Items[I] ;

      if Stop then
      begin
        Break;
      end;

//      inc_fret :=False ;// LowerCase(finc_fret.AsString)='t';

//      vlr_fret :=fvlr_fret.AsCurrency ;
//      vlr_desc :=fvlr_desc.AsCurrency ;
//      vlr_out_da :=fvlr_out_da.AsCurrency ;

      // itens somente para doc regular
      if r_C100.cod_sit=csDocRegular then
      begin

          if ind_emi=emiTerc then
          begin
              und_item :=det.prod.uCom;
              EFD_Fiscal.Bloco_0.NewReg_0200(det.prod.cProd  ,
                                             det.prod.xProd ,
                                             det.prod.cEAN  ,
                                             und_item  ,
                                             itmRevenda ,
                                             det.prod.NCM
                                             );
              if det.prod.cProd = '' then
              begin
                AddLog('  REGISTRO 0200: Código do Item [%s] inválido! Id_Mov:%d',[det.prod.xProd,id_mov]);
              end ;
              if det.prod.xProd = '' then
              begin
                AddLog('  REGISTRO 0200: Descrição do Item [%s] inválido! Id_Mov:%d',[det.prod.xProd,id_mov]);
              end ;
          end;


          cfop     :=det.prod.CFOP;

          if r_C100.ind_oper = toEnt then
          begin
            case cfop of
              5101,5102: cfop :=1102 ;
              1405,5403,5405: cfop :=1403 ;
              6403: cfop :=2403 ;
            else
              if IntToStr(cfop)[1] = '5' then
              begin
                cfop :=1102;
              end
              else if IntToStr(cfop)[1] = '6' then
              begin
                cfop :=2102;
              end;
            end;
          end;

          vlr_item :=det.prod.vProd;
          vbc_icms :=det.imposto.ICMS.vBC;
          aliq_icms:=det.imposto.ICMS.pICMS;
          vlr_icms :=det.imposto.ICMS.vICMS;

          vbc_icmsst :=det.imposto.ICMS.vBCST;
          vlr_icmsst :=det.imposto.ICMS.vICMSST;

          vlr_ipi  :=det.imposto.IPI.vIPI;
          aliq_ipi :=det.imposto.IPI.pIPI;

          vlr_rbc  :=0;
          aliq_rbc :=det.imposto.ICMS.pRedBC;


          // inicializa CST ICMS
          if aliq_rbc>0 then
          begin
              cst_icms :=20;
          end
          else
            if Tefd_util.CFOP_IsST(cfop) then
            begin
              cst_icms :=60;
            end
            else begin
              cst_icms :=Ord(det.imposto.ICMS.CST);
            end;

          if cst_icms in[20,70] then
          begin
            vlr_rbc :=((100 -aliq_rbc)* vlr_item)/100 ;
          end;

          //13.10.2012 - zera ICMS para todas as cfop´s q estão em
          //1551,2551,1556,2556,1949,2949,1557,1403,2403,5403
          //e repassa para valor nao trib (vl_red_bc)
          if Tefd_util.CFOP_In(cfop,[1551,2551,1556,2556,1949,2949,1557])or
            Tefd_util.CFOP_IsST(cfop) then
          begin
              vlr_rbc  :=vlr_rbc +vbc_icms;
              vbc_icms :=0;
              aliq_icms:=0;
              vlr_icms :=0;
          end;

          //09.11.2012-cfop 6403 zerar ICMS somente nas saidas
          if (ind_ope=toSai)and(cfop=6403) then
          begin
              vbc_icms :=0;
              aliq_icms:=0;
              vlr_icms :=0;
          end;

          if not(r_C100.ind_emit=emiProp) then
          begin
              r_C100.ind_pgto :=tpAprz;

              r_C170 :=r_C100.registro_C170.AddNew;
              r_C170.nro_item 	 :=r_C100.registro_C170.Count;
              r_C170.cod_item 	 :=det.prod.cProd	;
              r_C170.descr_compl :=det.prod.xProd	;
              r_C170.qtd_item	   :=det.prod.qCom	;
              r_C170.und_item	   :=und_item ;
              r_C170.vl_item	   :=vlr_item ;
              r_C170.vl_desc     :=vlr_desc;
//              if inc_fret then
//              begin
//                  r_C170.vl_fret :=vlr_fret; //fvlr_fret.AsCurrency;
//              end;
              r_C170.vl_out_da   :=0; //vlr_out_da; //fvlr_out_da.AsCurrency;
              r_C170.ind_mov	   :=movFis;
              r_C170.cst_icms	   :=cst_icms;
              r_C170.cfop			   :=cfop;
              r_C170.cod_nat	   :='';
              r_C170.vl_bc_icms  :=vbc_icms;
              r_C170.aliq_icms	 :=aliq_icms;
              r_C170.vl_icms     :=vlr_icms;
              r_C170.vl_bc_icmsst:=vbc_icmsst;
              r_C170.vl_icmsst   :=vlr_icmsst;
              r_C170.vl_bc_ipi:=vbc_icms;
              r_C170.aliq_ipi	:=aliq_ipi ;
              r_C170.vl_ipi   :=vlr_ipi;

              if r_C100.ind_oper=toEnt then r_C170.cod_cta :=Self.CodCta_Ent
              else                          r_C170.cod_cta :=Self.CodCta_Sai;

          end ;

          r_C190 :=r_C100.registro_C190.IndexOf(cst_icms, cfop, aliq_icms);
          if r_C190 = nil then
          begin
              r_C190 :=r_C100.registro_C190.AddNew;
              r_C190.cst_icms  :=cst_icms;
              r_C190.cfop		   :=cfop;
              r_C190.per_icms  :=aliq_icms;
              r_C190.vl_oper :=(vlr_item -vlr_desc) +vlr_out_da +vlr_icmsst +vlr_ipi;

              r_C190.vl_bc_icms    :=vbc_icms;
              r_C190.vl_icms       :=vlr_icms;
              r_C190.vl_bc_icms_st :=vbc_icmsst;
              r_C190.vl_icms_st    :=vlr_icmsst;
              r_C190.vl_rbc        :=vlr_rbc;
              r_C190.vl_ipi        :=vlr_ipi;
          end
          else begin
              r_C190.vl_oper :=r_C190.vl_oper +(vlr_item -vlr_desc) ;
              r_C190.vl_oper := r_C190.vl_oper +
                                vlr_out_da+
                                vlr_icmsst+
                                vlr_ipi;

              r_C190.vl_bc_icms		:=r_C190.vl_bc_icms 		+vbc_icms;
              r_C190.vl_icms			:=r_C190.vl_icms				+vlr_icms;
              r_C190.vl_bc_icms_st:=r_C190.vl_bc_icms_st	+vbc_icmsst;
              r_C190.vl_icms_st		:=r_C190.vl_icms_st		+vlr_icmsst;
              r_C190.vl_rbc				:=r_C190.vl_rbc				+vlr_rbc;
              r_C190.vl_ipi				:=r_C190.vl_ipi				+vlr_ipi;
          end;
      end;

    end;
  finally
    nfe.Free;
  end;

end;

procedure TSpedFiscal.DoFillEFD_C400;
var
  Q: TUniQuery ;

var
  r_C400: ufisbloco_C.Tregistro_C400;
  r_C405: ufisbloco_C.Tregistro_C405;
  r_C420: Tregistro_C420;
  r_C460: Tregistro_C460;
  r_C470: Tregistro_C470;
  r_C490: Tregistro_C490;

var
  emp_codigo: Integer;
  emp_cnpj: string;

  cod_mod : string ;
  ecf_mod : string ;
  ecf_fab : string ;
  num_cx	 : Integer;

  dt_doc :TDateTime;
  cro    :Integer;
  crz    :Integer;
  num_coo_ini  :Integer;
  num_coo_fin  :Integer;
  num_coo_aux  :Integer;
  gt_fin       :Currency;
  vl_brt       :Currency;

  dt_old:TDateTime;

  cod_tot_par	:string ;
  vl_acum_tot	:Currency;
  nr_tot: Byte;

var
  cod_sit: TCodSitDoc ;
  num_doc: Integer;
  cod_item: string;//Integer;
  und_item: string;
  qtd_item: Currency;
  vlr_item: Currency;
  vlr_unit: Currency;
  cst_icms: Word;
  cfop: Word;

  vbc_icms,
  aliq_icms,
  vlr_icms:Currency;
  item_canc: Byte;
  cod_tot: string ;

var
  codmun: Integer ;
  cupons: Integer ;

var
  C: Integer ;
  I,J,K: Integer;

begin

  //
  AddLog('Carregando ECF´s do mes %s',[FormatDateTime('mmm/yyyy', filter.DtaFin)]);
  Q :=inherited LoadDocFis01_C400();
  try

    while not Q.Eof do
    begin

      if Stop then
      begin
        Break;
      end;

      //11.02.2014-gonzaga, check se a redução tem movimento nestas condicoes!
      if fmov_count.AsInteger = 0 then
      begin
        Q.Next ;
        Continue ;
      end;

      emp_codigo :=femp_codigo.AsInteger ;
      emp_cnpj   :=femp_cnpj.AsString;

      cod_mod  :=fcod_mod.AsString;
      ecf_mod  :=fecf_mod.AsString;
      ecf_fab  :=fecf_fab.AsString;
      num_cx	 :=fnum_cx.AsInteger;

      dt_doc :=fdt_doc.AsDateTime;
      cro    :=fcro.AsInteger ;
      crz    :=fcrz.AsInteger ;
      num_coo_ini  :=fnum_coo_ini.AsInteger ;
      num_coo_fin  :=fnum_coo_fin.AsInteger ;
      gt_fin       :=fgt_fin.AsCurrency ;
      vl_brt       :=fvl_brt.AsCurrency ;

      r_C400 :=EFD_Fiscal.Bloco_C.NewReg_C400(cod_mod, ecf_mod, ecf_fab);
      if r_C400.Status = rsNew then
      begin
        r_C400.ecf_cx:=num_cx ;
      end
      else begin
        if num_cx > 0 then
        begin
          r_C400.ecf_cx :=num_cx ;
        end;
      end;

      r_C405 :=r_C400.registro_C405.IndexOf(crz) ;
      if r_C405 = nil then
      begin
        r_C405 :=r_C400.registro_C405.AddNew ;
        r_C405.dt_doc :=dt_doc ;
        r_C405.cro :=cro ;
        r_C405.crz :=crz ;
        r_C405.num_coo_fin :=num_coo_fin ;
        r_C405.gt_fin :=gt_fin ;
        r_C405.vl_brt :=vl_brt ;
      end ;

      cod_tot_par :=Trim(fcod_tot_par.AsString);
      cod_tot_par :=StringReplace(cod_tot_par, ',', '', [rfReplaceAll]);
      vl_acum_tot :=fvl_acum_tot.AsCurrency;

      if(cod_tot_par = '')or(vl_acum_tot = 0) then
      begin
        Q.Next ;
        Continue ;
      end;

      aliq_icms   :=0 ;
      case cod_tot_par[1] of
        '0'..'9':
        begin

          //24.02.2014-Devido a ma formação do cod. do totalizador pelo PAF-ECF
          //so permite cod. do totalizador no formato: 0700, 1200, 1700, 2500, 2700
          if Length(cod_tot_par)<>4 then
          begin
            Q.Next ;
            Continue;
          end;

          nr_tot :=1;
          aliq_icms   :=StrToCurrDef(cod_tot_par, 0)/100;
          cod_tot_par :=Format('%.2dT%s',[nr_tot,cod_tot_par]);
        end;
        'F':
        begin
          nr_tot :=0;
          cod_tot_par :=Format('F%d',[nr_tot]);
          cod_tot_par :='F1';
        end;
        'I':
        begin
          nr_tot :=0;
          cod_tot_par :=Format('I%d',[nr_tot]);
          cod_tot_par :='I1';
        end;
        'N':
        begin
          nr_tot :=0;
          cod_tot_par :=Format('N%d',[nr_tot]);
          cod_tot_par :='N1';
        end;
        'D':
        begin
          nr_tot :=0;
          cod_tot_par :='DT';
        end;
        'C':
        begin
          nr_tot :=0;
          cod_tot_par :='Can-T';
        end;
      else
        nr_tot :=0;
        cod_tot_par :='Não-Definido';
      end;

      r_C420 :=r_C405.registro_C420.IndexOf(cod_tot_par, nr_tot) ;
      if r_C420 = nil then
      begin
        r_C420 :=r_C405.registro_C420.AddNew ;
        r_C420.cod_tot_par :=cod_tot_par ;
        r_C420.vlr_acum_tot:=vl_acum_tot ;
        r_C420.nr_tot      :=nr_tot;
      end;

      Q.Next ;
    end;

  finally
    AddLog('%d ECF(s) encontradas.',[EFD_Fiscal.Bloco_C.registro_C001.registro_C400.Count]);
    FreeAndNil(Q);
  end;

  if Stop then Exit ;

  for I :=0 to EFD_Fiscal.Bloco_C.registro_C001.registro_C400.Count -1 do
  begin
    r_C400 :=EFD_Fiscal.Bloco_C.registro_C001.registro_C400.Items[I] ;

    if Stop then
    begin
      Break;
    end;

    for J :=0 to r_C400.registro_C405.Count - 1 do
    begin
      r_C405 :=r_C400.registro_C405.Items[J] ;

      if Stop then
      begin
        Break;
      end;

      cupons :=0 ;
      AddLog('Carregando cupons da ECF:%s e dia:%.2d',[r_C400.ecf_fab,DayOfTheMonth(r_C405.dt_doc)]);
      Q :=LoadDocFis01_C460(emp_codigo, r_C400.ecf_fab, r_C405.dt_doc) ;
      try
        while not Q.Eof do
        begin

          if Stop then
          begin
            Break;
          end;

          id_mov  :=fid_mov.AsInteger ;
          cod_sit :=TCodSitDoc(fcod_sit.AsInteger) ;
          num_doc :=fnum_doc.AsInteger;
          dt_doc  :=fdta_emi.AsDateTime;
          r_C460  :=r_C405.registro_C460.IndexOf(cod_mod, num_doc, dt_doc) ;
          if r_C460 = nil then
          begin
            r_C460 :=r_C405.registro_C460.AddNew ;
            r_C460.cod_mod :=cod_mod ;
            r_C460.cod_sit :=cod_sit ;
            r_C460.num_doc :=num_doc ;
            r_C460.dt_doc :=dt_doc ;
            Inc(cupons) ;
          end;

          qtd_item :=fqtd_item.AsCurrency;
          vlr_unit :=fvlr_unit.AsCurrency;
          vlr_item :=fvlr_tot.AsCurrency;  //qtd_item *vlr_unit;
          vbc_icms :=vlr_item;
          cfop     :=fcfop.AsInteger;
          item_canc:=fcanc_item.AsInteger;
          cod_tot :=Trim(fcod_tot.AsString);

//          if r_C460.cod_sit = csDocRegular then
          if(r_C460.cod_sit = csDocRegular)and(item_canc = 0)then
          begin
            cod_item :=fcod_item.AsString;
            und_item :=funid_inv.AsString ;

            EFD_Fiscal.Bloco_0.NewReg_0200(cod_item,
                                           fdescr_item.AsString ,
                                           fcod_barra.AsString  ,
                                           und_item  ,
                                           itmRevenda ,
                                           fcod_ncm.AsString  ,
                                           fcod_gen.AsInteger);

            if cod_item = '' then
            begin
              AddLog('    REGISTRO 0200: Código do Item [%s] inválido! Id_Ped:%d',[fdescr_item.AsString,id_mov]);
            end ;
            if fdescr_item.AsString = '' then
            begin
              AddLog('    REGISTRO 0200: Descrição do Item [%d] inválido! Id_Ped:%d',[cod_item,id_mov]);
            end ;

            if cod_tot = '' then
            begin
              case cst_icms of
                00: cod_tot :='3';
                40: cod_tot :='I';
                30,60: cod_tot :='F';
              end;
            end;

            case cod_tot[1] of
              '1': aliq_icms :=7;
              '2': aliq_icms :=12;
              '3': aliq_icms :=17;
              '4': aliq_icms :=25;
              '5': aliq_icms :=27;
            else
              aliq_icms :=0;
              vbc_icms  :=0;
            end;

            if Tefd_util.CFOP_IsST(cfop) then
            begin
              cst_icms :=60;
            end
            else begin
              cst_icms :=fcst_icms.AsInteger;
            end;

            if cst_icms in[30,40,41,50,60] then
            begin
              aliq_icms :=0;
              vbc_icms  :=0;
            end;

            if cst_icms = 60 then
            begin
              cfop :=5405 ;
            end;

            vlr_icms :=vbc_icms * (aliq_icms /100);

            r_C470 :=r_C460.registro_C470.AddNew;
            r_C470.cod_item :=cod_item ;
            r_C470.qtd_item :=qtd_item ;
            r_C470.unid_item:=und_item ;
            r_C470.vl_item  :=vlr_item ;
            r_C470.cst_icms :=cst_icms ;
            r_C470.cfop :=cfop ;
            r_C470.aliq_icms :=aliq_icms;

            if item_canc = 0 then
            begin

              r_C490 :=r_C405.registro_C490.IndexOf(cst_icms, cfop, aliq_icms);
              if r_C490 = nil then
              begin
                r_C490 :=r_C405.registro_C490.AddNew;
                r_C490.cst_icms  :=cst_icms;
                r_C490.cfop		   :=cfop;
                r_C490.per_icms  :=aliq_icms;
                r_C490.vl_opr    :=vlr_item ;
                r_C490.vl_bc_icms    :=vbc_icms;
                r_C490.vl_icms       :=vlr_icms;
              end
              else begin
                r_C490.vl_opr :=r_C490.vl_opr +vlr_item;
                r_C490.vl_bc_icms		:=r_C490.vl_bc_icms 		+vbc_icms;
                r_C490.vl_icms			:=r_C490.vl_icms				+vlr_icms;
              end;

            end;

          end;

          Q.Next ;
        end;

      finally
        AddLog('%d cupons encontrados.',[cupons]);
        FreeAndNil(Q);
      end;

    end;

  end;

end;

procedure TSpedFiscal.DoFillEFD_C400FromFile(const AFileName: string);
var
  r_0190: Tregistro_0190;
  r_C400: ufisbloco_C.Tregistro_C400;
  r_C405: ufisbloco_C.Tregistro_C405;
  r_C420: Tregistro_C420;
  r_C460: Tregistro_C460;
  r_C470: Tregistro_C470;
  r_C490: Tregistro_C490;
  //
var
  F: TextFile ;
  L,S,R,V: string;
begin
  if not FileExists(AFileName) then
  begin
    Exit
    ;
  end;

  {$I-}
  AssignFile(F, AFileName);
  try
    FileMode :=0;
    Reset(F);
    AddLog('Abriu arquivo "%s"',[AFileName]);
    while not Eof(F) do
    begin
      Readln(F, L);

      S :=L ;
      R :=Tefd_util.ExtVal(S) ;

      if R = '0190' then
      begin
        AddLog(' '+ L);
        und_item :=Tefd_util.ExtVal(S);
        r_0190 :=EFD_Fiscal.Bloco_0.NewReg_0190(und_item, V);
        r_0190.descri :=Tefd_util.ExtVal(S);
      end

      else if R = '0200' then
      begin
        AddLog(' '+ L);
        cod_item  :=Tefd_util.ExtVal(S);
        descr_item:=Tefd_util.ExtVal(S);
        cod_barra :=Tefd_util.ExtVal(S); Tefd_util.ExtVal(S) ;
        und_item  :=Tefd_util.ExtVal(S);
        EFD_Fiscal.Bloco_0.NewReg_0200(cod_item  ,
                                       descr_item,
                                       cod_barra ,
                                       und_item  );
      end

      else if R = 'C400' then
      begin
        AddLog(' '+ L);
        cod_mod :=Tefd_util.ExtVal(S);
        ecf_mod :=Tefd_util.ExtVal(S);
        ecf_fab :=Tefd_util.ExtVal(S);
        r_C400  :=EFD_Fiscal.Bloco_C.NewReg_C400(cod_mod, ecf_mod, ecf_fab);
        r_C400.ecf_cx :=Tefd_util.ExtValInt(S) ;
      end

      else if R = 'C405' then
      begin
        AddLog(' '+ L);
        r_C405 :=r_C400.registro_C405.AddNew ;
        r_C405.dt_doc     :=Tefd_util.ExtValDat(S) ;
        r_C405.cro        :=Tefd_util.ExtValInt(S) ;
        r_C405.crz        :=Tefd_util.ExtValInt(S) ;
        r_C405.num_coo_fin:=Tefd_util.ExtValInt(S) ;
        r_C405.gt_fin     :=Tefd_util.ExtValCur(S) ;
        r_C405.vl_brt     :=Tefd_util.ExtValCur(S) ;
      end

      else if R = 'C420' then
      begin
//        V :=Tefd_util.ExtVal(S) ;
//        if V = 'OPNF' then
//        begin
//          Continue ;
//        end;
        AddLog(' '+ L);
        r_C420 :=r_C405.registro_C420.AddNew ;
        r_C420.cod_tot_par :=Tefd_util.ExtVal(S) ;
        r_C420.vlr_acum_tot:=Tefd_util.ExtValCur(S) ;
        r_C420.nr_tot      :=Tefd_util.ExtValInt(S) ;
      end

      else if R = 'C460' then
      begin
        AddLog(' '+ L);
        r_C460 :=r_C405.registro_C460.AddNew ;
        r_C460.cod_mod :=Tefd_util.ExtVal(S) ;
        r_C460.cod_sit :=TCodSitDoc(Tefd_util.ExtValInt(S)) ;
        r_C460.num_doc :=Tefd_util.ExtValInt(S) ;
        r_C460.dt_doc  :=Tefd_util.ExtValDat(S) ;
      end

      else if R = 'C470' then
      begin
        AddLog(' '+ L);
        r_C470 :=r_C460.registro_C470.AddNew;
        r_C470.cod_item :=Tefd_util.ExtVal(S) ;
        r_C470.qtd_item :=Tefd_util.ExtValCur(S) ; Tefd_util.ExtVal(S) ;
        r_C470.unid_item:=Tefd_util.ExtVal(S) ;
        r_C470.vl_item  :=Tefd_util.ExtValCur(S);
        r_C470.cst_icms :=Tefd_util.ExtValInt(S);
        r_C470.cfop     :=Tefd_util.ExtValInt(S);
        r_C470.aliq_icms:=Tefd_util.ExtValCur(S);
        if r_C470.cst_icms = 30 then
        begin
          r_C470.cfop :=5403 ;
        end;
      end

      else if R = 'C490' then
      begin
        AddLog(' '+ L);
        r_C490 :=r_C405.registro_C490.AddNew;
        r_C490.cst_icms  :=Tefd_util.ExtValInt(S) ;
        r_C490.cfop		   :=Tefd_util.ExtValInt(S) ;
        r_C490.per_icms  :=Tefd_util.ExtValCur(S) ;
        r_C490.vl_opr    :=Tefd_util.ExtValCur(S) ;
        r_C490.vl_bc_icms:=Tefd_util.ExtValCur(S) ;
        r_C490.vl_icms   :=Tefd_util.ExtValCur(S) ;
        if r_C490.cst_icms = 30 then
        begin
          r_C490.cfop :=5403 ;
        end;
      end
      ;
    end;

  finally
    CloseFile(F);
    AddLog('Fechou arquivo "%s"',[AFileName]);
//    DeleteFile(AFileName) ;
  end;
  {$I+}
end;

procedure TSpedFiscal.DoLoadBH();
var
    Q: TUniQuery	;
var
    r_H005: Tregistro_H005	;
    r_H010: Tregistro_H010	;

var
    cod_part: string ;
    cod_item: Integer;
    und_item: string ;
    qtd_item: Currency;

begin

{    Q	:=TUniQuery.NewQuery();

		q.sql.Add('select                                                        ');
		q.sql.Add('  p.pro00_codigo       as cod_item	,                          ');
    q.sql.Add('  p.pro00_descri       as descr_item,                         ');
    q.sql.Add('  p.pro00_codbar       as cod_barra ,                         ');
    q.sql.Add('  p.pro00_unidad       as unid_inv ,                          ');
    if TMetaData.ObjExists('cadpro00', 'pro00_codncm') then
    begin
      q.sql.Add('  p.pro00_codncm as cod_ncm,     ');
    end
    else begin
      q.sql.Add('  null as pro_codncm,            ');
    end;
    if TMetaData.ObjExists('cadpro00', 'pro00_codgen') then
    begin
      q.sql.Add('  p.pro00_codgen as cod_gen,     ');
    end
    else begin
      q.sql.Add('  %d as cod_gen,                 ',[TDefValue.COD_GEN_ITEM]);
    end;
    if TMetaData.ObjExists('ettpro00', 'pro00_qtdetm') then
    begin
      q.sql.Add('  s.pro00_qtdetm       as qtd_item	,                          ');
      q.sql.Add('  s.pro00_pcocstcss    as vlr_unit	,                          ');
      q.sql.Add('  s.pro00_qtdetm*s.pro00_pcocstcss as vlr_tot,                ');
    end
    else begin
      q.sql.Add('  s.pro00_qtdesttotdep as qtd_item	,                         ');
      q.sql.Add('  s.pro00_vlrestcusmed as vlr_unit	,                         ');
      //q.sql.Add('  s.pro00_qtdesttotdep*s.pro00_vlrestcusdep as vlr_tot,      ');
      q.sql.Add('  s.pro00_qtdesttotdep*s.pro00_vlrestcusmed as vlr_tot,      ');
    end;
    q.sql.Add('  for00_codigo as part_cod,                                   ');
    q.sql.Add('  for00_descri as part_nome    ,                              ');
    q.sql.Add('  for00_fj     as part_typpes  ,                              ');
    q.sql.Add('  case when for00_fj=''F'' then for00_cic end  as part_cpf ,  ');
    q.sql.Add('  case when for00_fj=''J'' then for00_cic end  as part_cnpj,  ');
    q.sql.Add('  for00_insest as part_ie      ,                              ');
    q.sql.Add('  for00_ende   as part_endere  ,                              ');
    q.sql.Add('  for00_bairro as part_bairro  ,                              ');
    q.sql.Add('  cid00_ibgecod as part_codmun ,                              ');
    q.sql.Add('  est00_sigla	as part_uf 		                                 ');

		q.sql.Add('from ettpro00 s(nolock)                                       ');
    q.sql.Add('inner join cadpro00 p(nolock) on p.pro00_codigo=s.pro00_codpro');
    q.sql.Add('inner join cadfor00 (nolock) on for00_codigo = pro00_codfab   ');
    q.sql.Add('left  join cadcid00    (nolock) on cid00_codigo = for00_codcid');
    q.sql.Add('left  join cadest00    (nolock) on est00_codigo = for00_codest');
		q.sql.Add('where s.pro00_codfil = %d                                     ',[filter.CodEmp]);
		q.sql.Add('and   s.pro00_ano    = %d                                     ',[filter.RefAno]);
		q.sql.Add('and   s.pro00_mes    = %d                                     ',[filter.RefMes]);

    if Q.OpenTryBoo then
    begin
      r_H005          :=EFD_Fiscal.Bloco_H.registro_H001.registro_H005.AddNew;
      r_H005.dta_inv  :=EndOfAMonth(filter.RefAno, filter.RefMes);

      fcod_item  :=q.Field('cod_item')	;
      fdescr_item:=q.Field('descr_item');
      fcod_barra :=q.Field('cod_barra')	;
      funid_inv  :=q.Field('unid_inv');
      fcod_ncm   :=q.Field('cod_ncm');
      fcod_gen   :=q.Field('cod_gen');
      fqtd_item  :=q.Field('qtd_item');
      fvlr_unit  :=q.Field('vlr_unit');
      fvlr_tot   :=q.Field('vlr_tot')	;

      fpart_cod	  :=Q.Field('part_cod') ;
      fpart_nome  :=Q.Field('part_nome');
      fpart_typpes:=Q.Field('part_typpes');
      fpart_cpf   :=Q.Field('part_cpf') ;
      fpart_cnpj  :=Q.Field('part_cnpj');
      fpart_ie    :=Q.Field('part_ie') ;
      fpart_endere:=Q.Field('part_endere');
      fpart_bairro:=Q.Field('part_bairro');
      fpart_codmun:=Q.Field('part_codmun');
      fpart_uf		:=Q.Field('part_uf') ;

      while not q.Eof do
      begin
          qtd_item :=fqtd_item.AsCurrency ;
          if qtd_item > 0 then
          begin
              cod_part :='F' +Tefd_util.FInt(fpart_cod.AsInteger, 6);
              EFD_Fiscal.Bloco_0.NewReg_0150(cod_part,
                                            fpart_nome.AsString ,
                                            Tefd_util.GetNumbers(fpart_cnpj.AsString) ,
                                            Tefd_util.GetNumbers(fpart_cpf.AsString) ,
                                            Tefd_util.GetNumbers(fpart_ie.AsString) ,
                                            fpart_endere.AsString, '',
                                            fpart_bairro.AsString,
                                            fpart_codmun.AsInteger);

              cod_item  :=fcod_item.AsInteger ;
              und_item  :=UpperCase(funid_inv.AsString)	;
              EFD_Fiscal.Bloco_0.NewReg_0200(cod_item  ,
                                             fdescr_item.AsString  ,
                                             fcod_barra.AsString  ,
                                             und_item  ,
                                             itmRevenda ,
                                             fcod_ncm.AsString  ,
                                             fcod_gen.AsInteger);

              r_H010  :=r_H005.registro_H010.AddNew	;
              r_H010.cod_item	:=fcod_item.AsInteger	;
              r_H010.ind_prop :=piInfoPosseTer;
              r_H010.und_item	:=und_item;
              r_H010.qtd_item	:=qtd_item;
              r_H010.vlr_unit	:=fvlr_unit.AsCurrency;
              r_H010.vlr_tot	:=fvlr_tot.AsCurrency;
              r_H010.cod_part	:=cod_part	;
              r_H010.cod_cta  :=Self.CodCta_Ent;
          end;

          q.Next;
      end;
    end;
    q.Destroy	;
    }
end;

function TSpedFiscal.Execute(AFilter: TfilterEFD; p:TGetStrProc): Boolean;
var
  r_H005: Tregistro_H005;
var
  I: Integer ;
begin
    filter :=AFilter;

    //NF-e entradas
    if Assigned(filter.EFD_NFeEnt)and(filter.EFD_NFeEnt.Count > 0) then
    begin
      for I :=0 to filter.EFD_NFeEnt.Count -1 do
      begin
        DoFillEFD_C100FromFile(filter.EFD_NFeEnt.Strings[I], emiTerc) ;
      end;
    end
    else
      DoFillEFD;

    //NF-e saidas
    if Assigned(filter.EFD_NFe)and(filter.EFD_NFe.Count > 0) then
    begin
      for I :=0 to filter.EFD_NFe.Count -1 do
      begin
        DoFillEFD_C100FromFile(filter.EFD_NFe.Strings[I]) ;
      end;
    end;

    if not filter.NoRegC400 then
    begin
      if Assigned(filter.EFD_Saidas)and(filter.EFD_Saidas.Count > 0) then
      begin
        for I :=0 to filter.EFD_Saidas.Count -1 do
        begin
          DoFillEFD_C400FromFile(filter.EFD_Saidas.Strings[I]) ;
        end;
      end
      else
        DoFillEFD_C400
        ;
    end;
    DoFillBD;

    if Self.RetCod = TLoadEFD.COD_LOAD_SUCESS then
    begin
      Result := True;
      if filter.IndInv then
      begin
          DoLoadBH();
          if EFD_Fiscal.Bloco_H.registro_H001.registro_H005.Count>0 then
          begin
            r_H005  :=EFD_Fiscal.Bloco_H.registro_H001.registro_H005.Items[0];
            r_H005.mot_inv :=filter.MotInv ;
          end;
      end;

      if Self.Path <> '' then
      begin
        fFileName :='\SPED_FISCAL-'+ UpperCase(FormatDateTime('mmmyyyy', filter.DtaFin)) +'.EFD';
      end
      else begin
        fFileName :='SPED_FISCAL-'+ UpperCase(FormatDateTime('mmmyyyy', filter.DtaFin)) +'.EFD';
      end;

      EFD_Fiscal.Execute(Path + fFileName);

      fFileName :=EFD_Fiscal.FileName;

    end
    else
      Result := False;
end;

function TSpedFiscal.Load(AFilter: TfilterEFD): Word;
begin

end;

function TSpedFiscal.LoadFromDir(const ALocalDir: string): Boolean;
var
  jsf: TJvSearchFiles;
  //

  //
begin
  jsf :=TJvSearchFiles.Create(nil) ;
  try

    jsf.DirOption :=doExcludeSubDirs ;
    jsf.DirParams.Attributes.Archive :=tsMustBeSet ;
    jsf.DirParams.SearchTypes :=[stAttribute,stFileMask] ;
    jsf.FileParams.Attributes.Archive :=tsMustBeSet ;
    jsf.FileParams.FileMask :='*.EFD' ;
    jsf.FileParams.SearchTypes :=[stAttribute,stFileMask] ;
    jsf.RootDirectory :=ALocalDir ;

    if jsf.Search then
    begin

    end;


  finally
    jsf.Free ;
  end;
end;

{ TSpedContrib }

constructor TSpedContrib.Create;
begin
  inherited Create();
  EFD_Contrib :=TEFD_Contrib.Create;
  EFD :=EFD_Contrib ;
//  AddLog('Iniciou objeto EFD-Contribuíções');
  AddLog('Iniciou objeto %s',[Self.ClassName]);
end;

destructor TSpedContrib.Destroy;
begin
  EFD :=nil ;
  EFD_Contrib.Destroy;
  inherited Destroy ;
  AddLog('Finalizou objeto TSpedContrib');
end;

procedure TSpedContrib.DoFillBD;
var
    Q: TUniQuery;
var
    r_D010: uctrbloco_D.Tregistro_D010 ;
    r_D100: uctrbloco_D.Tregistro_D100 ;
    r_D101: uctrbloco_D.Tregistro_D101 ;
    r_D105: uctrbloco_D.Tregistro_D105 ;

var
    ind_emi: TIndEmiDoc;
    num_doc: Integer ;
    cod_mod: string;
    ser_doc: String;
    sub_ser: String;
    cod_par: string;
var
    cst_pis: Word ;

begin

    Q := inherited LoadDocFis02;
    try
        if(Q = nil) or(fRetCod<>0) then
        begin
            Exit;
        end;

        while not Q.Eof do
        begin
            cod_par :='F' +Tefd_util.FInt(fpart_cod.AsInteger, 6);
            EFD_Contrib.Bloco_0.NewReg_0150(cod_par ,
                                           fpart_nome.AsString  ,
                                           Tefd_util.GetNumbers(fpart_cnpj.AsString) ,
                                           Tefd_util.GetNumbers(fpart_cpf.AsString)  ,
                                           Tefd_util.GetNumbers(fpart_ie.AsString) ,
                                           fpart_endere.AsString , '',
                                           fpart_bairro.AsString ,
                                           fpart_codmun.AsInteger);

            ind_emi:=emiProp ;
            num_doc:=fnum_doc.AsInteger;
            cod_mod:=Tefd_util.FInt(fcod_mod.AsInteger,2)  ;
            ser_doc:=fser_doc.AsString;
            sub_ser:=fsub_ser.AsString;

            r_D010 :=EFD_Contrib.Bloco_D.NewReg_D010(Tefd_util.GetNumbers(femp_cnpj.AsString));

            r_D100 :=r_D010.NewReg_D100(ind_emi,
                                        num_doc,
                                        cod_mod,
                                        ser_doc,
                                        sub_ser,
                                        cod_par);
            if r_D100.Status =rsNew then
            begin
                r_D100.cod_sit :=csDocRegular ;
                r_D100.dta_doc :=fdta_emi.AsDateTime;
                r_D100.vl_doc :=fvlr_tot.AsCurrency;
                r_D100.ind_fret:=tfDest;
                r_D100.vl_serv:=fvlr_tot.AsCurrency;
                r_D100.vl_icms:=fvlr_icms.AsCurrency;
            end;

            cst_pis:=50 ;

            r_D101 :=r_D100.registro_D101.AddNew ;
            r_D101.ind_nat_frt :=natfret_2;
            r_D101.vlr_item :=fvlr_tot.AsCurrency  ;
            r_D101.cst_pis :=cst_pis  ;
            r_D101.nat_bc_cred :='14' ;
            r_D101.vlr_bc_pis :=fvlr_tot.AsCurrency  ;
            r_D101.aliq_pis :=TDefValue.ALIQ_PIS ;

            r_D105 :=r_D100.registro_D105.AddNew ;
            r_D105.ind_nat_frt :=natfret_2;
            r_D105.vlr_item :=fvlr_tot.AsCurrency  ;
            r_D105.cst_cofins :=50  ;
            r_D105.nat_bc_cred :='14' ;
            r_D105.vlr_bc_cofins :=fvlr_tot.AsCurrency  ;
            r_D105.aliq_cofins :=TDefValue.ALIQ_COFINS ;

            Q.Next;
        end;

    finally
        if Assigned(Q) then Q.Free ;
    end;
end;

procedure TSpedContrib.DoFillEFD;
var
  Q: TUniQuery;
var
  r_0140: uctrbloco_0.Tregistro_0140;
  r_C010: uctrbloco_C.Tregistro_C010;
  r_C100: uctrbloco_C.Tregistro_C100;
  r_C170: EFDCommon.Tregistro_C170; //  uctrbloco_C.Tregistro_C170;

var
  cst_pis:Word;
  aliq_pis:Currency;
  cst_cofins:Word;
  aliq_cofins:Currency;
  cls_fis:Byte;
  vlr_tot:Currency;
var
  codmun: Integer ;

begin
    //
    AddLog('Carregando notas fiscais modelo (01/55/65) de %s',[FormatDateTime('mmm/yyyy', filter.DtaFin)]);
    Q := inherited LoadDocFis01;
    try
        with EFD_Contrib.Bloco_0.registro_0001 do
        begin
          registro_0110.cod_inc_trib:=citRegNCum;
          registro_0110.ind_apr_cred:=cacDireta;
          registro_0110.cod_tip_cntr:=ctcAliqBas;
          registro_0110.ind_reg_cum :=crcCaixa;
        end;

        while not Q.Eof do
        begin

            if Stop then
            begin
              Break;
            end;

            // estabelecimento
            r_0140 :=EFD_Contrib.Bloco_0.NewReg_0140(
                femp_codigo.AsInteger,
                femp_nome.AsString   ,
                Tefd_util.GetNumbers(femp_cnpj.AsString),
                femp_uf.AsString ,
                Tefd_util.GetNumbers(femp_ie.AsString),
                femp_codmun.AsInteger);

            r_C010 :=EFD_Contrib.Bloco_C.NewReg_C010(r_0140.cnpj, '');

            SetVars(False) ;
            aliq_rbc :=faliq_rbc.AsCurrency ;


            // doc´s entradas/saidas
            r_C100 :=EFD_Contrib.Bloco_C.NewReg_C100(r_C010 ,
                                                     ind_ope,
                                                     ind_emi,
                                                     part_cod,
                                                     cod_mod,
                                                     ser_doc,
                                                     cod_sit,
                                                     num_doc);

            if r_C100.Status = rsNew then
            begin
                r_C100.chv_nfe :=chv_nfe ;
                r_C100.dta_emi :=fdta_emi.AsDateTime;
                r_C100.dta_e_s :=fdta_e_s.AsDateTime;
                r_C100.ind_pgto:=tpOut ;
                r_C100.ind_fret:=TIndTypFret(find_fret.AsInteger);
                r_C100.vl_fret  :=fvlr_fret.AsCurrency;
                r_C100.vl_out_da:=fvlr_out_da.AsCurrency;
                r_C100.vl_desc  :=fvlr_desc.AsCurrency;
            end;

            cst_pis    :=StrToIntDef(Trim(fcst_pis.Value), 99);
            aliq_pis   :=faliq_pis.AsCurrency ;
            cst_cofins :=StrToIntDef(Trim(fcst_cofins.Value), 99);
            aliq_cofins:=faliq_cofins.AsCurrency;

            case r_C100.ind_oper of
                toEnt:// CST PIS/COFINS - ENTRADA
                //Entrada de bonificação, doação ou brinde
                if Tefd_util.CFOP_In(cfop,[1910,2910]) then
                begin
                    // Operação de Aquisição a Alíquota Zero
                    cst_pis  :=73;
                    aliq_pis :=0 ;
                    cst_cofins :=cst_pis;
                    aliq_cofins:=aliq_pis;
                end

                else if Tefd_util.CFOP_In(cfop,[1409,2409,1551,2551,1556,2556,1557,2922,2923,2949])then
                begin
                    // Outras Operações de Entrada
                    cst_pis :=98;
                    aliq_pis:=0;
                    cst_cofins  :=cst_pis;
                    aliq_cofins :=aliq_pis;
                end

                else begin
//                    if cls_fis in[1..4,9] then
//                    begin
                        cst_pis :=50; // Operação com Direito a Crédito - Vinculada Exclusivamente a
                                      // Receita Tributada no Mercado Interno
                        if aliq_pis<>TDefValue.ALIQ_PIS then
                        begin
                            aliq_pis :=TDefValue.ALIQ_PIS ;
                        end;
                        cst_cofins :=cst_pis;
                        if aliq_cofins<>TDefValue.ALIQ_COFINS then
                        begin
                            aliq_cofins :=TDefValue.ALIQ_COFINS;
                        end;
//                    end
//
//                    else if cls_fis >= 5 then
//                    begin
//                        cst_pis  :=73; // Operação de Aquisição a Alíquota Zero
//                        aliq_pis :=0  ;
//                        cst_cofins :=cst_pis;
//                        aliq_cofins:=aliq_pis;
//                    end;
                end;

                toSai:// CST PIS/COFINS - SAIDA
                //Remessa em bonificação, doação ou brinde
//                if (cls_fis in[1..4])or(Tefd_util.CFOP_In(cfop,[5910,6910])) then
                if Tefd_util.CFOP_In(cfop,[5910,6910]) then
                begin
                    cst_pis :=1; // Operação Tributável com Alíquota Básica
                    if aliq_pis<>TDefValue.ALIQ_PIS then
                    begin
                        aliq_pis :=TDefValue.ALIQ_PIS ;
                    end;
                    cst_cofins :=cst_pis;
                    if aliq_cofins<>TDefValue.ALIQ_COFINS then
                    begin
                        aliq_cofins :=TDefValue.ALIQ_COFINS;
                    end;
                end;
//                else if cls_fis >= 5 then
//                else begin
//                    cst_pis:=6; // Operação Tributável a Alíquota Zero
//                    aliq_pis:=0;
//                    cst_cofins :=cst_pis;
//                    aliq_cofins:=aliq_pis;
//                end;
            end;

            // itens somente para doc regular
            if r_C100.cod_sit=csDocRegular then
            begin
//                vlr_item :=fqtd_item.AsCurrency *fvlr_unit.AsCurrency;
//                vbc_icms :=fvlr_bc_icms.AsCurrency;
//                aliq_icms:=faliq_icms.AsCurrency;
//                vlr_icms :=fvlr_icms.AsCurrency;
//                vlr_rbc	 :=fvlr_rbc.AsFloat;

                {if inc_fret then
                begin
                    vbc_icms :=vbc_icms +fvlr_bc_fret.AsCurrency ;
                    vlr_icms :=vlr_icms +fvlr_icmsfret.AsCurrency;
                end;}

                //inicializa CST ICMS
                if vlr_rbc>0 then
                begin
                    cst_icms	:=20;
                end
                else if Tefd_util.CFOP_IsST(cfop) then
                begin
                    cst_icms :=10;
                end
                else begin
                    cst_icms :=fcst_icms.AsInteger ;
                end;

                if cst_icms in[20,70] then
                begin
                  vlr_rbc :=((100 -aliq_rbc)* vlr_item)/100 ;
                end;

                {//13.10.2012 - zera ICMS para todas as cfop´s q estão em
                //1551,2551,1556,2556,1949,2949,1557,1403,2403,5403
                //e repassa para valor nao trib (vl_red_bc)
                if Tefd_util.CFOP_In(cfop,[1551,2551,1556,2556,1949,2949,1557])or
                	Tefd_util.CFOP_IsST(cfop) then
                begin
                  	vlr_rbc  :=vlr_rbc +vbc_icms;
                    vbc_icms :=0;
                    aliq_icms:=0;
                    vlr_icms :=0;
                end;

                //09.11.2012-cfop 6403 zerar ICMS somente nas saidas
                if (ind_ope=toSai)and(cfop=6403) then
                begin
                    vbc_icms :=0;
                    aliq_icms:=0;
                    vlr_icms :=0;
                end;}

                r_C170 :=r_C100.registro_C170.AddNew;
                r_C170.nro_item 	 :=r_C100.registro_C170.Count;
                r_C170.cod_item 	 :=cod_item	;
                r_C170.descr_compl :=descr_item	;
                r_C170.qtd_item	   :=qtd_item	;
                r_C170.und_item	   :=und_item ;
                r_C170.vl_item	   :=vlr_item ;

                case r_C100.ind_emit of
                  emiProp:begin
                      vlr_tot :=vlr_item +fvlr_icmsst.AsCurrency
                                         +fvlr_ipi.AsCurrency;
                  end;
                  emiTerc:begin
                      vlr_tot :=(vlr_item -fvlr_desc.AsCurrency);
//                      if inc_fret then
//                      begin
//                          vlr_tot :=vlr_tot +fvlr_fret.AsCurrency;
//                          r_C170.vl_fret:=fvlr_fret.AsCurrency;
//                      end ;
                      vlr_tot :=vlr_tot +fvlr_out_da.AsCurrency
                                        +fvlr_icmsst.AsCurrency
                                        +fvlr_ipi.AsCurrency;
                      r_C170.vl_desc  :=fvlr_desc.AsCurrency;
                      r_C170.vl_out_da:=fvlr_out_da.AsCurrency;
                  end;
                else
                  vlr_tot :=0;
                end;

                r_C170.ind_mov	   :=movFis;
                r_C170.cst_icms	   :=cst_icms;
                r_C170.cfop			   :=cfop	;
                r_C170.cod_nat	   :='';
                r_C170.vl_bc_icms	 :=vbc_icms;
                r_C170.aliq_icms   :=aliq_icms;
                r_C170.vl_icms     :=vlr_icms;
                r_C170.vl_bc_icmsst:=fvlr_bc_icmsst.AsCurrency;
                r_C170.vl_icmsst   :=fvlr_icmsst.AsCurrency	;
                r_C170.aliq_ipi    :=faliq_ipi.AsFloat;
                r_C170.vl_ipi      :=fvlr_ipi.AsCurrency;
                r_C170.cst_pis     :=cst_pis;
                r_C170.vl_bc_pis   :=vlr_tot;
                r_C170.aliq_pis    :=aliq_pis;
                r_C170.cst_cofins  :=cst_cofins;
                r_C170.vl_bc_cofins:=vlr_tot;
                r_C170.aliq_cofins :=aliq_cofins;

                if r_C100.ind_oper=toEnt then r_C170.cod_cta :=Self.CodCta_Ent
                else                          r_C170.cod_cta :=Self.CodCta_Sai;

                if not(cst_pis in[98,99])and(aliq_pis=0)then
                begin
                    r_C170.vl_bc_pis :=0;
                end ;

                if not(cst_cofins in[98,99])and(aliq_cofins=0)then
                begin
                    r_C170.vl_bc_cofins:=0;
                end ;
            end;

            Q.Next;
        end;
    finally
      AddLog('%d notas fiscais encontradas.',[Q.RecordCount]);
      Q.Destroy;
    end;
end;

procedure TSpedContrib.DoFillEFD_C100FromFile(const AFileName: string;
  const EmiDoc: TIndEmiDoc);
var
  r_0190: Tregistro_0190;
  r_0140: uctrbloco_0.Tregistro_0140;
  r_C010: uctrbloco_C.Tregistro_C010;
  r_C100: uctrbloco_C.Tregistro_C100;
  r_C170: EFDCommon.Tregistro_C170;
var
  nfe: TNFe ;
  det: TnfeDet;
var
  I: Integer ;
  L,S,R,V: string;
var
//  ind_ope: TIndTypOper;
//  ind_emi: TIndEmiDoc ;
//  cod_sit: TCodSitDoc ;
  cod_par: string ;
  chv_nfe: string;
  ind_fret:TIndTypFret;
//  cod_mod: string ;
//  ser_doc: string ;
//  num_doc: Integer;
//  inc_fret:Boolean;
//  chv_nfe: string;
//var
//  cod_item: Integer;
//  und_item: string;
//  vlr_item: Currency;
//  vlr_fret: Currency;
//  vlr_desc: Currency;
//  vlr_out_da: Currency;
//  cst_icms: Word;
//  cfop: Word;
//
//  vbc_icms,
//  aliq_icms,
//  vlr_icms:Currency;
//  vlr_rbc: Currency;
//  vlr_icmsst: Currency;
//  vlr_ipi: Currency;

  cst_pis:Word;
  aliq_pis:Currency;
  cst_cofins:Word;
  aliq_cofins:Currency;
  cls_fis:Byte;
  vlr_tot:Currency;
  tip_item: TItemTyp;

begin

  if not FileExists(AFileName) then
  begin
    Exit
    ;
  end;
  AddLog('Importando NFe: %s',[AFileName]);

  nfe :=TNFe.Create ;
  try
    nfe.LoadFromFile(AFileName, S);

    id_mov :=1;
    ind_emi :=EmiDoc;
    cod_sit :=csDocRegular ;
    if ind_emi = emiProp then
    begin
      ind_ope :=toSai ;
      cod_par :=nfe.dest.CNPJ;
      if cod_par = '' then
      begin
          cod_par :=nfe.dest.CPF;
      end;
    end
    else begin
      ind_ope :=toEnt ;
      nfe.ide.dSaiEnt :=nfe.ide.dEmi ;
      cod_par :=nfe.emit.CNPJ;
    end;

    ind_fret:=tfDest;
    chv_nfe :=nfe.Id ;
    cod_mod :=Copy(chv_nfe,21,2);
    if chv_nfe <> '' then
    begin
      if cod_mod = '65' then
      begin
        ind_fret:=tfNone ;
      end;
    end
    else begin
      cod_mod :='55';
    end;

    ser_doc :=Tefd_util.FInt(nfe.ide.serie, 3, '000');
    num_doc :=nfe.ide.nNF;

    // somente os doc´s.cuja situacao estao regular
    if cod_sit=csDocRegular then
    begin
        // participantes
        if ind_emi = emiProp then
        begin
          if cod_mod = '55' then
          begin
            nfe.dest.ender.xLgr :=StringReplace(nfe.dest.ender.xLgr, '|', ',', [rfReplaceAll]);
            EFD_Contrib.Bloco_0.NewReg_0150(cod_par,
                                           nfe.dest.xNome ,
                                           nfe.dest.CNPJ ,
                                           nfe.dest.CPF ,
                                           nfe.dest.IE ,
                                           nfe.dest.ender.xLgr,
                                           nfe.dest.ender.xCpl,
                                           nfe.dest.ender.xBairro,
                                           nfe.dest.ender.cMun);
          end;
        end
        else begin
          EFD_Contrib.Bloco_0.NewReg_0150(cod_par,
                                         nfe.emit.xNome, // nfe.dest.xNome ,
                                         nfe.emit.CNPJ, //nfe.dest.CNPJ ,
                                         '', //nfe.dest.CPF ,
                                         nfe.emit.IE, // nfe.dest.IE ,
                                         nfe.emit.ender.xLgr, // nfe.dest.ender.xLgr,
                                         nfe.emit.ender.xCpl, // nfe.dest.ender.xCpl,
                                         nfe.emit.ender.xBairro, // nfe.dest.ender.xBairro,
                                         nfe.emit.ender.cMun // nfe.dest.ender.cMun
                                         );
        end;
    end;

    // estabelecimento
    r_0140 :=EFD_Contrib.Bloco_0.NewReg_0140(Self.CodEmp ,
                                            Self.Nome   ,
                                            Self.CNPJ,
                                            Self.UF ,
                                            Self.IE,
                                            Self.CodMun );

    r_C010 :=EFD_Contrib.Bloco_C.NewReg_C010(r_0140.cnpj, '');

    // doc´s entrada/saida
    r_C100 :=EFD_Contrib.Bloco_C.NewReg_C100(r_C010,
                                            ind_ope,
                                            ind_emi,
                                            cod_par,
                                            cod_mod,
                                            ser_doc,
                                            cod_sit,
                                            num_doc);
    r_C100.chv_nfe :=chv_nfe ;
    r_C100.dta_emi :=nfe.ide.dEmi;
    r_C100.dta_e_s :=nfe.ide.dSaiEnt;
    r_C100.ind_pgto:=tpOut ;
    r_C100.ind_fret:=ind_fret;
    r_C100.vl_fret :=nfe.total.vFrete;
    r_C100.vl_out_da:=nfe.total.vOutro;
    r_C100.vl_desc  :=nfe.total.vDesc;

    cst_pis    :=99;
    aliq_pis   :=0.00;
    cst_cofins :=99;
    aliq_cofins:=0.00;

    case r_C100.ind_oper of
        toEnt:// CST PIS/COFINS - ENTRADA
        //Entrada de bonificação, doação ou brinde
        if Tefd_util.CFOP_In(cfop,[1910,2910]) then
        begin
            // Operação de Aquisição a Alíquota Zero
            cst_pis  :=73;
            aliq_pis :=0 ;
            cst_cofins :=cst_pis;
            aliq_cofins:=aliq_pis;
        end

        else if Tefd_util.CFOP_In(cfop,[1409,2409,1551,2551,1556,2556,1557,2922,2923,2949])then
        begin
            // Outras Operações de Entrada
            cst_pis :=98;
            aliq_pis:=0;
            cst_cofins  :=cst_pis;
            aliq_cofins :=aliq_pis;
        end

        else begin
            // Operação com Direito a Crédito - Vinculada Exclusivamente a
            // Receita Tributada no Mercado Interno
            cst_pis :=50;
            if aliq_pis<>TDefValue.ALIQ_PIS then
            begin
                aliq_pis :=TDefValue.ALIQ_PIS ;
            end;
            cst_cofins :=cst_pis;
            if aliq_cofins<>TDefValue.ALIQ_COFINS then
            begin
                aliq_cofins :=TDefValue.ALIQ_COFINS;
            end;
        end;

        toSai:// CST PIS/COFINS - SAIDA
        //Remessa em bonificação, doação ou brinde
        if Tefd_util.CFOP_In(cfop,[5910,6910]) then
        begin
            cst_pis :=1; // Operação Tributável com Alíquota Básica
            if aliq_pis<>TDefValue.ALIQ_PIS then
            begin
                aliq_pis :=TDefValue.ALIQ_PIS ;
            end;
            cst_cofins :=cst_pis;
            if aliq_cofins<>TDefValue.ALIQ_COFINS then
            begin
                aliq_cofins :=TDefValue.ALIQ_COFINS;
            end;
        end;
    end;

    // itens somente para doc regular
    if r_C100.cod_sit=csDocRegular then
    begin

      for I :=0 to nfe.det.Count -1 do
      begin
        det :=nfe.det.Items[I] ;

        if Stop then
        begin
          Break;
        end;

        cod_item :=det.prod.cProd ;
        cod_barra :=det.prod.cEAN  ;
        descr_item :=det.prod.xProd;
        und_item :=det.prod.uCom ;
        tip_item :=itmRevenda;
        cod_ncm :=det.prod.NCM ;
        //cod_gen :=det.prod.;

        cfop :=det.prod.CFOP;

        vlr_item :=det.prod.vProd;
        vlr_desc :=det.prod.vDesc;
        vlr_out_da:=det.prod.vOutro;

        vbc_icms :=det.imposto.ICMS.vBC;
        aliq_icms:=det.imposto.ICMS.pICMS;
        vlr_icms :=det.imposto.ICMS.vICMS;

        vbc_icmsst :=det.imposto.ICMS.vBCST;
        vlr_icmsst :=det.imposto.ICMS.vICMSST;

        vlr_ipi  :=det.imposto.IPI.vIPI;
        aliq_ipi :=det.imposto.IPI.pIPI;

        vlr_rbc  :=0;
        aliq_rbc :=det.imposto.ICMS.pRedBC;


        if ind_ope = toEnt then
        begin
          case cfop of
            5101,5102: cfop :=1102 ;
            1405,5403,5405: cfop :=1403 ;
            6403: cfop :=2403 ;
          else
            if IntToStr(cfop)[1] = '5' then
            begin
              cfop :=1102;
            end
            else if IntToStr(cfop)[1] = '6' then
            begin
              cfop :=2102;
            end;
          end;
        end;

        // Transferência de material de uso ou consumo
        if cfop=5557 then
        begin
          tip_item :=itmMatCons;
        end ;

        if Tefd_util.CFOP_IsST(cfop) then
        begin
          cst_icms :=60;
        end ;

        if cst_icms in[30,40,41,50,60] then
        begin
          aliq_icms :=0;
          vbc_icms  :=0;
        end;

        r_C170 :=r_C100.registro_C170.AddNew;
        r_C170.nro_item 	 :=r_C100.registro_C170.Count;
        r_C170.cod_item 	 :=cod_item	;
        r_C170.descr_compl :=descr_item	;
        r_C170.qtd_item	   :=qtd_item	;
        r_C170.und_item	   :=und_item ;
        r_C170.vl_item	   :=vlr_item ;

        case r_C100.ind_emit of
          emiProp:begin
              vlr_tot :=vlr_item +vlr_icmsst
                                 +vlr_ipi;
          end;
          emiTerc:begin
              vlr_tot :=vlr_item -vlr_desc;
              vlr_tot :=vlr_tot +vlr_out_da
                                +vlr_icmsst
                                +vlr_ipi;
              r_C170.vl_desc  :=vlr_desc;
              r_C170.vl_out_da:=vlr_out_da;
          end;
        else
          vlr_tot :=0;
        end;

        r_C170.ind_mov	   :=movFis;
        r_C170.cst_icms	   :=cst_icms;
        r_C170.cfop			   :=cfop	;
        r_C170.cod_nat	   :='';
        r_C170.vl_bc_icms	 :=vbc_icms;
        r_C170.aliq_icms   :=aliq_icms;
        r_C170.vl_icms     :=vlr_icms;
        r_C170.vl_bc_icmsst:=vbc_icmsst;
        r_C170.vl_icmsst   :=vlr_icmsst;
        r_C170.aliq_ipi    :=aliq_ipi;
        r_C170.vl_ipi      :=vlr_ipi;
        r_C170.cst_pis     :=cst_pis;
        r_C170.vl_bc_pis   :=vlr_tot;
        r_C170.aliq_pis    :=aliq_pis;
        r_C170.cst_cofins  :=cst_cofins;
        r_C170.vl_bc_cofins:=vlr_tot;
        r_C170.aliq_cofins :=aliq_cofins;

        if r_C100.ind_oper=toEnt then r_C170.cod_cta :=Self.CodCta_Ent
        else                          r_C170.cod_cta :=Self.CodCta_Sai;

        if not(cst_pis in[98,99])and(aliq_pis=0)then
        begin
            r_C170.vl_bc_pis :=0;
        end ;

        if not(cst_cofins in[98,99])and(aliq_cofins=0)then
        begin
            r_C170.vl_bc_cofins:=0;
        end ;

      end;

    end;

  finally
    nfe.Free;
  end;

end;

procedure TSpedContrib.DoFillEFD_C400;
var
  Q: TUniQuery ;

var
  r_0140: uctrbloco_0.Tregistro_0140;
  r_C010: uctrbloco_C.Tregistro_C010;
  r_C400: uctrbloco_C.Tregistro_C400;
  r_C405: uctrbloco_C.Tregistro_C405;

  r_C481: Tregistro_C481;
  r_C485: Tregistro_C485;

var
  emp_codigo: Integer;
  emp_nome: string ;
  emp_cnpj: string;
  emp_ie: string ;
  emp_uf: string ;
  emp_codmun: Integer ;

  cod_mod : string ;
  ecf_mod : string ;
  ecf_fab : string ;
  num_cx	 : Integer ;

  dt_doc :TDateTime;
  cro    :Integer;
  crz    :Integer;
  num_coo_ini  :Integer;
  num_coo_fin  :Integer;
  num_coo_aux  :Integer;
  gt_fin       :Currency;
  vl_brt       :Currency;

var
  cst_pis,cst_cofins: Byte;
  vl_bc_pis, vl_bc_cofins: Currency;
  aliq_pis, aliq_cofins: Currency;
  vl_pis, vl_cofins: Currency;
  item_canc: Byte;

var
  codmuni: Integer;
var
  I,J,K: Integer ;

var
  ECFs: Integer ;
  cupons: Integer ;
  pis_itens, cofins_itens: Integer ;

begin

  //
  AddLog('Carregando ECF´s do mes %s',[FormatDateTime('mmm/yyyy', filter.DtaFin)]);
  Q :=inherited LoadDocFis01_C400();
  try

    with EFD_Contrib.Bloco_0.registro_0001 do
    begin
        registro_0110.cod_inc_trib:=citRegNCum;
        registro_0110.ind_apr_cred:=cacDireta;
        registro_0110.cod_tip_cntr:=ctcAliqBas;
        registro_0110.ind_reg_cum :=crcCaixa;
    end;

    ECFs :=0 ;
    while not Q.Eof do
    begin

      if Stop then
      begin
        Break;
      end;

      emp_codigo :=femp_codigo.AsInteger ;
      emp_nome   :=femp_nome.AsString;
      emp_cnpj   :=Tefd_util.GetNumbers(femp_cnpj.AsString);
      emp_ie   :=Tefd_util.GetNumbers(femp_ie.AsString);
      emp_uf    :=femp_ie.AsString;
      emp_codmun :=femp_codmun.AsInteger ;

      // estabelecimento
      r_0140 :=EFD_Contrib.Bloco_0.NewReg_0140(emp_codigo,
          emp_nome,
          emp_cnpj,
          emp_uf,
          emp_ie,
          emp_codmun);

      r_C010 :=EFD_Contrib.Bloco_C.NewReg_C010(r_0140.cnpj, '');

      cod_mod  :=fcod_mod.AsString;
      ecf_mod  :=fecf_mod.AsString;
      ecf_fab  :=fecf_fab.AsString;
      num_cx	 :=fnum_cx.AsInteger;

      dt_doc :=fdt_doc.AsDateTime;
      cro    :=fcro.AsInteger ;
      crz    :=fcrz.AsInteger ;
      num_coo_ini  :=fnum_coo_ini.AsInteger ;
      num_coo_fin  :=fnum_coo_fin.AsInteger ;
      gt_fin       :=fgt_fin.AsCurrency ;
      vl_brt       :=fvl_brt.AsCurrency ;

      //11.02.2014-gonzaga, check se a redução tem movimento nestas condicoes!
      if fmov_count.AsInteger = 0 then
      begin
        Q.Next ;
        Continue ;
      end;

      r_C400 :=EFD_Contrib.Bloco_C.NewReg_C400(r_C010, cod_mod, ecf_mod, ecf_fab);
      if r_C400.Status = rsNew then
      begin
        r_C400.ecf_cx :=num_cx ;
        Inc(ECFs) ;
      end
      else begin
        if num_cx > 0 then
        begin
          r_C400.ecf_cx :=num_cx ;
        end;
      end;

      r_C405 :=r_C400.registro_C405.IndexOf(crz) ;
      if r_C405 = nil then
      begin
        r_C405 :=r_C400.registro_C405.AddNew ;
        r_C405.dt_doc :=dt_doc ;
        r_C405.cro :=cro ;
        r_C405.crz :=crz ;
        r_C405.num_coo_fin :=num_coo_fin ;
        r_C405.gt_fin :=gt_fin ;
        r_C405.vl_brt :=vl_brt ;
      end ;

      Q.Next ;
    end;

  finally
    AddLog('%d ECF(s) encontradas.',[ECFs]);
    Q.Destroy ;
  end;

  if Stop then Exit ;

  for I :=0 to EFD_Contrib.Bloco_C.registro_C001.registro_C010.Count -1 do
  begin
    r_C010 :=EFD_Contrib.Bloco_C.registro_C001.registro_C010.Items[I] ;

    if Stop then
    begin
      Break;
    end;

    for J :=0 to r_C010.registro_C400.Count -1 do
    begin
      r_C400 :=r_C010.registro_C400.Items[J] ;

      if Stop then
      begin
        Break;
      end;

      for K :=0 to r_C400.registro_C405.Count - 1 do
      begin
        r_C405 :=r_C400.registro_C405.Items[K] ;

        if Stop then
        begin
          Break;
        end;

        pis_itens :=0;
        cofins_itens :=0 ;
        AddLog('Carregando PIS/COFINS por itens de cupons da ECF:%s e dia:%.2d',[r_C400.ecf_fab,DayOfTheMonth(r_C405.dt_doc)]);
        Q :=LoadDocFis01_C460(emp_codigo, r_C400.ecf_fab, r_C405.dt_doc) ;
        try
          while not Q.Eof do
          begin

            if Stop then
            begin
              Break;
            end;

            SetVars(True) ;
            item_canc :=fcanc_item.AsInteger;

            cst_pis    :=StrToIntDef(Trim(fcst_pis.Value), 99) ;
            aliq_pis   :=faliq_pis.AsCurrency ;
            cst_cofins :=StrToIntDef(Trim(fcst_cofins.Value), 99) ;
            aliq_cofins:=faliq_cofins.AsCurrency;

            if Tefd_util.CFOP_In(cfop,[5910,6910]) then
            begin
              cst_pis :=1; // Operação Tributável com Alíquota Básica
              if aliq_pis<>TDefValue.ALIQ_PIS then
              begin
                aliq_pis :=TDefValue.ALIQ_PIS ;
              end;
              cst_cofins :=cst_pis;
              if aliq_cofins<>TDefValue.ALIQ_COFINS then
              begin
                aliq_cofins :=TDefValue.ALIQ_COFINS;
              end;
            end;
//            else begin
//              cst_pis:=6; // Operação Tributável a Alíquota Zero
//              aliq_pis:=0;
//              cst_cofins :=cst_pis;
//              aliq_cofins:=aliq_pis;
//            end;

            if item_canc = 0 then
            begin
              r_C481 :=r_C405.registro_C481.IndexOf(cst_pis, cod_item) ;
              if r_C481 = nil then
              begin
                r_C481 :=r_C405.registro_C481.AddNew ;
                r_C481.cst_pis :=cst_pis ;
                r_C481.vl_item :=vlr_item ;
                r_C481.vl_bc_pis :=vlr_item ;
                r_C481.aliq_pis :=aliq_pis ;
                r_C481.cod_item :=cod_item ;
                Inc(pis_itens) ;
              end
              else begin
                r_C481.vl_item    :=r_C481.vl_item    +vlr_item ;
                r_C481.vl_bc_pis  :=r_C481.vl_bc_pis  +vlr_item ;
              end;

              r_C485 :=r_C405.registro_C485.IndexOf(cst_cofins, cod_item) ;
              if r_C485 = nil then
              begin
                r_C485 :=r_C405.registro_C485.AddNew ;
                r_C485.cst_cofins   :=cst_pis ;
                r_C485.vl_item      :=vlr_item ;
                r_C485.vl_bc_cofins :=vlr_item ;
                r_C485.aliq_cofins  :=aliq_pis ;
                r_C485.cod_item     :=cod_item ;
                Inc(cofins_itens) ;
              end
              else begin
                r_C485.vl_item      :=r_C485.vl_item      +vlr_item ;
                r_C485.vl_bc_cofins :=r_C485.vl_bc_cofins +vlr_item ;
              end;

              if not(cst_pis in[98,99])and(aliq_pis=0)then
              begin
                r_C481.vl_bc_pis :=0;
              end ;

              if not(cst_cofins in[98,99])and(aliq_cofins=0)then
              begin
                r_C485.vl_bc_cofins:=0;
              end ;

            end;

            Q.Next ;
          end;

        finally
          AddLog('%d PIS/Item & %d COFINS/Item encontrados.', [pis_itens,cofins_itens]);
          FreeAndNil(Q);
        end;

      end;

    end;

  end;

end;

procedure TSpedContrib.DoFillEFD_C400FromFile(const AFileName: string);
var
  r_0190: Tregistro_0190;
  r_0140: uctrbloco_0.Tregistro_0140;
  r_C010: uctrbloco_C.Tregistro_C010;
  r_C400: uctrbloco_C.Tregistro_C400;
  r_C405: uctrbloco_C.Tregistro_C405;
  //

var
  F: TextFile ;
  L,S,R,V: string;
begin
  if not FileExists(AFileName) then
  begin
    Exit
    ;
  end;

  {$I-}
  AssignFile(F, AFileName);
  try
    FileMode :=0;
    Reset(F);
    AddLog('Abriu arquivo "%s"',[AFileName]);

    with EFD_Contrib.Bloco_0.registro_0001 do
    begin
        registro_0110.cod_inc_trib:=citRegNCum;
        registro_0110.ind_apr_cred:=cacDireta;
        registro_0110.cod_tip_cntr:=ctcAliqBas;
        registro_0110.ind_reg_cum :=crcCaixa;
    end;

    // estabelecimento
    r_0140 :=EFD_Contrib.Bloco_0.NewReg_0140(1,
        EFD_Contrib.Bloco_0.registro_0000.nome,
        EFD_Contrib.Bloco_0.registro_0000.cnpj,
        EFD_Contrib.Bloco_0.registro_0000.uf,
        '', //emp_ie,
        EFD_Contrib.Bloco_0.registro_0000.cod_mun);

    r_C010 :=EFD_Contrib.Bloco_C.NewReg_C010(r_0140.cnpj, '');


    while not Eof(F) do
    begin
      Readln(F, L);

      S :=L ;
      R :=Tefd_util.ExtVal(S) ;

      if R = '0190' then
      begin
        AddLog(' '+ L);
        und_item :=Tefd_util.ExtVal(S);
        r_0190 :=EFD_Contrib.Bloco_0.NewReg_0190(und_item, V);
        r_0190.descri :=Tefd_util.ExtVal(S);
      end

      else if R = '0200' then
      begin
        AddLog(' '+ L);
        cod_item  :=Tefd_util.ExtVal(S);
        descr_item:=Tefd_util.ExtVal(S);
        cod_barra :=Tefd_util.ExtVal(S); Tefd_util.ExtVal(S) ;
        und_item  :=Tefd_util.ExtVal(S);
        EFD_Contrib.Bloco_0.NewReg_0200(cod_item  ,
                                       descr_item,
                                       cod_barra ,
                                       und_item  );
      end

      else if R = 'C400' then
      begin
        AddLog(' '+ L);
        cod_mod :=Tefd_util.ExtVal(S);
        ecf_mod :=Tefd_util.ExtVal(S);
        ecf_fab :=Tefd_util.ExtVal(S);
        r_C400  :=EFD_Contrib.Bloco_C.NewReg_C400(r_C010, cod_mod, ecf_mod, ecf_fab);
        r_C400.ecf_cx :=Tefd_util.ExtValInt(S) ;
      end

      else if R = 'C405' then
      begin
        AddLog(' '+ L);
        r_C405 :=r_C400.registro_C405.AddNew ;
        r_C405.dt_doc     :=Tefd_util.ExtValDat(S) ;
        r_C405.cro        :=Tefd_util.ExtValInt(S) ;
        r_C405.crz        :=Tefd_util.ExtValInt(S) ;
        r_C405.num_coo_fin:=Tefd_util.ExtValInt(S) ;
        r_C405.gt_fin     :=Tefd_util.ExtValCur(S) ;
        r_C405.vl_brt     :=Tefd_util.ExtValCur(S) ;
      end;

    end;

  finally
    CloseFile(F);
    AddLog('Fechou arquivo "%s"',[AFileName]);
//    DeleteFile(AFileName) ;
  end;
  {$I+}
end;

function TSpedContrib.Execute(AFilter: TfilterEFD): Boolean;
var
  I: Integer ;
begin
  filter :=AFilter;

  //NF-e entradas
  if Assigned(filter.EFD_NFeEnt)and(filter.EFD_NFeEnt.Count > 0) then
  begin
    for I :=0 to filter.EFD_NFeEnt.Count -1 do
    begin
      DoFillEFD_C100FromFile(filter.EFD_NFeEnt.Strings[I], emiTerc) ;
    end;
  end
  else
    DoFillEFD;

  //NF-e saidas
  if Assigned(filter.EFD_NFe)and(filter.EFD_NFe.Count > 0) then
  begin
    for I :=0 to filter.EFD_NFe.Count -1 do
    begin
      DoFillEFD_C100FromFile(filter.EFD_NFe.Strings[I]) ;
    end;
    fRetCod :=TLoadEFD.COD_LOAD_SUCESS;
  end;

  if not filter.NoRegC400 then
  begin
    if Assigned(filter.EFD_Saidas)and(filter.EFD_Saidas.Count > 0) then
    begin
      for I :=0 to filter.EFD_Saidas.Count -1 do
      begin
        DoFillEFD_C400FromFile(filter.EFD_Saidas.Strings[I]) ;
      end;
    end
    else
      DoFillEFD_C400
      ;
  end;

//  if not filter.NoRegC400 then DoFillEFD_C400;
  //DoFillBD ;

  if Self.RetCod = TLoadEFD.COD_LOAD_SUCESS then
  begin
      Result :=True ;
      if Self.Path <> '' then
      begin
        fFileName :='\SPED_CONTRIB-'+ UpperCase(FormatDateTime('mmmyyyy', filter.DtaFin)) +'.EFD';
      end
      else begin
        fFileName :='SPED_CONTRIB-'+ UpperCase(FormatDateTime('mmmyyyy', filter.DtaFin)) +'.EFD';
      end;

      EFD_Contrib.Execute(Path + fFileName);
      fFileName :=EFD_Contrib.FileName ;
  end
  else begin
      Result :=False;
  end;

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
      inherited Add(Result);
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
      Q.SQL.Add('where emp.id_filial > 0                ');
      Q.Open ;

      Result :=not Q.IsEmpty ;
      femp_codigo :=Q.Field('emp_codigo') ;
      femp_codmun :=Q.Field('emp_codmun') ;

      while not Q.Eof do
      begin

        E :=Self.AddNew(femp_codigo.AsInteger) ;
        E.Nome   :=Q.Field('emp_nome').AsString ;
        E.CNPJ   :=Tefd_util.GetNumbers(Q.Field('emp_cnpj').AsString) ;
        E.CodMun :=2111300;
        if(not femp_codmun.IsNull)and(femp_codmun.AsInteger > 0) then
        begin
          E.CodMun :=femp_codmun.AsInteger ;
        end ;
        E.UF :=Q.Field('emp_uf').AsString ;
        E.IE :=Tefd_util.GetNumbers(Q.Field('emp_ie').AsString) ;
        E.CEP:=Tefd_util.GetNumbers(Q.Field('emp_cep').AsString) ;
        E.Endere :=Q.Field('emp_endere').AsString ;
        E.Bairro :=Q.Field('emp_bairro').AsString ;
        E.Fone   :=Tefd_util.GetNumbers(Q.Field('emp_fone').AsString) ;

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

{$REGION 'Tcadcontab00List'}
  { Tcadcontab00List }

  function Tcadcontab00List.AddNew(const Codigo: Integer): Tcadcontab00;
  begin
    Result :=Self.IndexOf(Codigo) ;
    if Result = nil then
    begin
      Result :=Tcadcontab00.Create ;
      Result.FIndex :=Self.Count ;
      Result.ctb00_codigo :=Codigo ;
      inherited Add(Result);
    end;
  end;

  function Tcadcontab00List.ApplyUpdates(AContab: Tcadcontab00): Boolean;
  var
    C: TUniQuery;
  begin
    C :=TUniQuery.NewQuery();
    try
      case AContab.UpdateStatus  of
        usNewValue:
        begin
          C.AddCmd('insert into contador (id ');
          C.AddCmd('  ,contador              ');
          C.AddCmd('  ,cpf_contador          ');
          C.AddCmd('  ,crc_contador          ');
          C.AddCmd('  ,cnpj                  ');
          C.AddCmd('  ,cep                   ');
          C.AddCmd('  ,endereco              ');
          C.AddCmd('  ,bairro                ');
          C.AddCmd('  ,cod_municipio         ');
          C.AddCmd('  ,email )               ');
          C.AddCmd('values (gen_id(GEN_CONTADOR_ID,1)');
          C.AddCmd('  ,:ctb00_nome            ');
          C.AddCmd('  ,:ctb00_cpf             ');
          C.AddCmd('  ,:ctb00_crc             ');
          C.AddCmd('  ,:ctb00_cnpj            ');
          C.AddCmd('  ,:ctb00_cep             ');
          C.AddCmd('  ,:ctb00_endere          ');
          C.AddCmd('  ,:ctb00_bairro          ');
          C.AddCmd('  ,:ctb00_codmun          ');
          C.AddCmd('  ,:ctb00_email)          ');
        end;
        usUpdateValue:
        begin
          C.AddCmd('update contador set              ');
          C.AddCmd('  contador = :ctb00_nome         ');
          C.AddCmd('  ,cpf_contador =:ctb00_cpf      ');
          C.AddCmd('  ,crc_contador =:ctb00_crc      ');
          C.AddCmd('  ,cnpj =:ctb00_cnpj             ');
          C.AddCmd('  ,cep =:ctb00_cep               ');
          C.AddCmd('  ,endereco =:ctb00_endere       ');
          C.AddCmd('  ,bairro =:ctb00_bairro         ');
          C.AddCmd('  ,cod_municipio =:ctb00_codmun  ');
          C.AddCmd('  ,email =:ctb00_email           ');
          C.AddCmd('where id = :ctb00_codigo         ');
        end;
      end;

      C.AddParamStr('ctb00_nome', AContab.ctb00_nome, 50) ;
      C.AddParamStr('ctb00_cpf', AContab.ctb00_cpf, 11) ;
      C.AddParamStr('ctb00_crc', AContab.ctb00_crc, 15) ;
      C.AddParamStr('ctb00_cnpj', AContab.ctb00_cnpj, 14) ;
      C.AddParamStr('ctb00_cep', AContab.ctb00_cep, 8) ;
      C.AddParamStr('ctb00_endere', AContab.ctb00_endere, 30) ;
      C.AddParamStr('ctb00_bairro', AContab.ctb00_bairro, 20) ;
      C.AddParamStr('ctb00_codmun', IntToStr(AContab.ctb00_codmun), 7) ;
      C.AddParamStr('ctb00_email', AContab.ctb00_email, 200) ;

      if AContab.UpdateStatus = usUpdateValue then
      begin
        C.AddParamInt('ctb00_codigo', AContab.ctb00_codigo) ;
      end;

      try
        C.Execute ;
        Result :=True;
      except
        on E:EDAError do
        begin
          AContab.ErrCod :=E.ErrorCode ;
          AContab.ErrMsg :=E.Message ;
          Result :=False;
        end;
      end;

    finally
      C.Free ;
    end;
  end;

  function Tcadcontab00List.CLoad(const Codigo: Integer): Boolean;
  var
    Q: TUniQuery;
  var
    fctb00_codigo:TField;
    fctb00_nome:TField ;
    fctb00_cpf:TField  ;
    fctb00_crc:TField  ;
    fctb00_cnpj:TField ;
    fctb00_cep:TField  ;
    fctb00_endere:TField;
    fctb00_numero:TField;
    fctb00_comple:TField;
    fctb00_bairro:TField;
    fctb00_codmun:TField;
    fctb00_email:TField;
  var
    C: Tcadcontab00 ;
  begin
    Self.Clear ;
    Q :=TUniQuery.NewQuery();
    try
      Q.sql.Add('select id as ctb00_codigo,       ');
      Q.sql.Add('  contador as ctb00_nome,        ');
      Q.sql.Add('  cpf_contador as ctb00_cpf ,    ');
      Q.sql.Add('  crc_contador as ctb00_crc ,    ');
      Q.sql.Add('  cnpj as ctb00_cnpj,            ');
      Q.sql.Add('  cep as ctb00_cep ,             ');
      Q.sql.Add('  endereco as ctb00_endere ,     ');
      Q.sql.Add('  end_num as ctb00_numero ,      ');
      Q.sql.Add('  end_compl as ctb00_comple ,    ');
      Q.sql.Add('  bairro as ctb00_bairro ,       ');
      Q.sql.Add('  cod_municipio as ctb00_codmun ,');
      Q.sql.Add('  email as ctb00_email           ');
      Q.sql.Add('from contador                    ');
      if Codigo > 0 then
      begin
        Q.sql.Add('where id = %d', [Codigo]);
      end
      else
      begin
        Q.sql.Add('where id > 0');
      end;
      Q.sql.Add('order by ctb00_codigo    ');
      Q.Open ;
      Result :=not Q.IsEmpty ;
      if Result then
      begin
        fctb00_codigo :=Q.Field('ctb00_codigo');
        fctb00_nome :=Q.Field('ctb00_nome');
        fctb00_cpf :=Q.Field('ctb00_cpf') ;
        fctb00_crc :=Q.Field('ctb00_crc') ;
        fctb00_cnpj :=Q.Field('ctb00_cnpj');
        fctb00_cep :=Q.Field('ctb00_cep') ;
        fctb00_endere :=Q.Field('ctb00_endere');
        fctb00_numero :=Q.Field('ctb00_numero');
        fctb00_comple :=Q.Field('ctb00_comple');
        fctb00_bairro :=Q.Field('ctb00_bairro');
        fctb00_codmun :=Q.Field('ctb00_codmun');
        fctb00_email :=Q.Field('ctb00_email');
        while not Q.Eof do
        begin
          C :=Self.AddNew(fctb00_codigo.AsInteger) ;
          C.ctb00_nome :=fctb00_nome.AsString ;
          C.ctb00_cpf :=Tefd_util.GetNumbers(fctb00_cpf.AsString) ;
          C.ctb00_crc :=Tefd_util.GetNumbers(fctb00_crc.AsString) ;
          C.ctb00_cnpj :=Tefd_util.GetNumbers(fctb00_cnpj.AsString);
          C.ctb00_cep :=Tefd_util.GetNumbers(fctb00_cep.AsString) ;
          C.ctb00_endere :=fctb00_endere.AsString ;
          C.ctb00_numero :=fctb00_numero.AsString ;
          C.ctb00_comple :=fctb00_comple.AsString ;
          C.ctb00_bairro :=fctb00_bairro.AsString ;
          C.ctb00_codmun :=2111300 ;

          if(not fctb00_codmun.IsNull)and(fctb00_codmun.AsString <> '') then
          begin
            C.ctb00_codmun :=fctb00_codmun.AsInteger ;
          end;
          C.ctb00_email :=fctb00_email.AsString ;
          Q.Next ;
        end;
      end;
    finally
      Q.Destroy ;
    end;

  end;

  function Tcadcontab00List.IndexOf(const Codigo: Integer): Tcadcontab00;
  begin
    Result :=nil ;
    for Result in Self do
    begin
      if Result.ctb00_codigo = Codigo then
      begin
        Break ;
      end ;
    end;
    if Assigned(Result)and(Result.ctb00_codigo <> Codigo) then
    begin
      Result :=nil ;
    end ;
  end;

{$ENDREGION}

{$REGION 'TBaseLoadEFD'}

{ TBaseLoadEFD }

constructor TBaseLoadEFD.Create (ABaseEFD: TBaseEFD);
begin
  inherited Create();
  Instance :=Self ;
  EFD :=ABaseEFD ;
end;

destructor TBaseLoadEFD.Destroy;
begin
  Instance :=nil ;
  inherited;
end;

procedure TBaseLoadEFD.DoInitVars(const AReg_C400: Boolean);
var
  tip_item: TItemTyp;
begin

  id_mov  :=fid_mov.AsInteger;
  cod_sit :=TCodSitDoc(fcod_sit.AsInteger) ;
  num_doc :=fnum_doc.AsInteger;
  qtd_item :=fqtd_item.AsCurrency;
  vlr_unit :=fvlr_unit.AsCurrency;

  if AReg_C400 then
  begin
    vlr_item :=fvlr_item.AsCurrency;
    vbc_icms :=vlr_item;
  end
  else begin
    ind_ope :=TIndTypOper(find_oper.AsInteger);
    ind_emi :=TIndEmiDoc(find_emit.AsInteger);
    chv_nfe :=Trim(fchv_nfe.AsString) ;
    cod_mod :=Tefd_util.FInt(fcod_mod.AsInteger, 2);
    ser_doc :=Tefd_util.FInt(fser_doc.AsInteger, 3);
    part_cod :='';
    if fpart_cod.AsInteger > 0 then
    begin
      part_cod :=IfThen(ind_emi = emiTerc,'F','C') +Tefd_util.FInt(fpart_cod.AsInteger, 6);
    end;
    part_nome:=Trim(fpart_nome.AsString);
    part_cnpj:=Tefd_util.GetNumbers(fpart_cnpj.AsString);
    part_cpf :=Tefd_util.GetNumbers(fpart_cpf.AsString) ;
    part_ie  :=Tefd_util.GetNumbers(fpart_ie.AsString) ;
    part_endere:=Trim(fpart_endere.AsString) ;
    part_bairro:=Trim(fpart_bairro.AsString) ;
    part_codmun:=fpart_codmun.AsInteger;

    if ind_ope = toEnt then
    begin
      if Length(chv_nfe)=44 then
      begin
        if(chv_nfe[21]='5')and(chv_nfe[22]='5')then
        begin
          cod_mod :='55';
          num_doc :=StrToIntDef(Copy(chv_nfe, 26, 9), 0);
        end
        else begin
          cod_mod :='01';
          chv_nfe :='';
        end;
      end
      else begin
        cod_mod :='01';
        chv_nfe :='';
      end;
    end;

    vlr_item :=qtd_item *vlr_unit;
    vbc_icms :=fvlr_bc_icms.AsCurrency;
    aliq_rbc :=faliq_rbc.AsCurrency ;
  end;

  cod_item :=fcod_item.AsString ;
  cod_barra :=fcod_barra.AsString;
  descr_item :=fdescr_item.AsString;
  und_item :=funid_inv.AsString ;
  tip_item :=itmRevenda;
  cod_ncm :=fcod_ncm.AsString ;
  cod_gen :=fcod_gen.AsInteger;

  cst_icms :=fcst_icms.AsInteger;
  cfop     :=fcfop.AsInteger;
  aliq_icms:=faliq_icms.AsCurrency;

  if cod_sit = csDocRegular then
  begin

    if ind_ope = toEnt then
    begin
      case cfop of
        5101,5102: cfop :=1102 ;
        1405,5403,5405: cfop :=1403 ;
        6403: cfop :=2403 ;
      else
        if IntToStr(cfop)[1] = '5' then
        begin
          cfop :=1102;
        end
        else if IntToStr(cfop)[1] = '6' then
        begin
          cfop :=2102;
        end;
      end;
    end;

    // Transferência de material de uso ou consumo
    if cfop=5557 then
    begin
      tip_item :=itmMatCons;
    end ;

    if Tefd_util.CFOP_IsST(cfop) then
    begin
      cst_icms :=60;
    end ;

    if cst_icms in[30,40,41,50,60] then
    begin
      aliq_icms :=0;
      vbc_icms  :=0;
    end;

    vlr_icms :=vbc_icms * (aliq_icms /100);

    { EFD-ICMS/IPI }
    if EFD is TEFD_Fiscal then
    begin

      // inicializa CST ICMS
      if vlr_rbc>0 then
      begin
        cst_icms :=20;
      end
      else
        if Tefd_util.CFOP_IsST(cfop) then
        begin
          cst_icms :=60;
        end
        else begin
          cst_icms :=fcst_icms.AsInteger;
        end;

      if cst_icms in[20,70] then
      begin
        vlr_rbc :=((100 -aliq_rbc)* vlr_item)/100 ;
      end;

      //13.10.2012 - zera ICMS para todas as cfop´s q estão em
      //1551,2551,1556,2556,1949,2949,1557,1403,2403,5403
      //e repassa para valor nao trib (vl_red_bc)
      if Tefd_util.CFOP_In(cfop,[1551,2551,1556,2556,1949,2949,1557])or
        Tefd_util.CFOP_IsST(cfop) then
      begin
        vlr_rbc  :=vlr_rbc +vbc_icms;
        vbc_icms :=0;
        aliq_icms:=0;
        vlr_icms :=0;
      end;

      //09.11.2012-cfop 6403 zerar ICMS somente nas saidas
      if (ind_ope=toSai)and(cfop=6403) then
      begin
        vbc_icms :=0;
        aliq_icms:=0;
        vlr_icms :=0;
      end;

      if cst_icms = 60 then
      begin
        cfop :=5405 ;
      end;

      //Não ah participantes para o REGISTRO C400
      if not AReg_C400 then
      begin
        TEFD_Fiscal(EFD).Bloco_0.NewReg_0150(part_cod,
                                            part_nome ,
                                            part_cnpj ,
                                            part_cpf ,
                                            part_ie ,
                                            part_endere, '',
                                            part_bairro,
                                            part_codmun);
        if part_cod = '' then
        begin
          AddLog('REGISTRO 0150: Código do participante [%s] inválido! Id_Mov:%d!',[part_nome,id_mov]);
        end ;
        if part_nome = '' then
        begin
          AddLog('REGISTRO 0150: Nome do participante [%s] inválido! Id_Mov:%d!',[part_cod,id_mov]);
        end ;
      end;

      if ind_emi=emiTerc then
      begin
        TEFD_Fiscal(EFD).Bloco_0.NewReg_0200(cod_item  ,
                                       descr_item ,
                                       cod_barra  ,
                                       und_item  ,
                                       tip_item ,
                                       cod_ncm, cod_gen);
        if cod_item = '' then
        begin
          AddLog('REGISTRO 0200: Código do Item [%s] inválido! Id_Mov:%d',[fdescr_item.AsString,id_mov]);
        end ;
        if fdescr_item.AsString = '' then
        begin
          AddLog('REGISTRO 0200: Descrição do Item [%d] inválido! Id_Mov:%d',[cod_item,id_mov]);
        end ;
      end;
    end

    { EFD-Contribuições }
    else if EFD is TEFD_Contrib then
    begin
      //Não ah participantes para o REGISTRO C400
      if not AReg_C400 then
      begin
        TEFD_Contrib(EFD).Bloco_0.NewReg_0150(part_cod,
                                            part_nome ,
                                            part_cnpj ,
                                            part_cpf ,
                                            part_ie ,
                                            part_endere, '',
                                            part_bairro,
                                            part_codmun);
        if part_cod = '' then
        begin
          AddLog('REGISTRO 0150: Código do participante [%s] inválido! Id_Mov:%d!',[part_nome,id_mov]);
        end ;
        if part_nome = '' then
        begin
          AddLog('REGISTRO 0150: Nome do participante [%s] inválido! Id_Mov:%d!',[part_cod,id_mov]);
        end ;
      end;
      TEFD_Contrib(EFD).Bloco_0.NewReg_0200(cod_item  ,
                                           descr_item ,
                                           cod_barra  ,
                                           und_item  ,
                                           tip_item ,
                                           cod_ncm, cod_gen);
    end;
  end;
end;

procedure TBaseLoadEFD.DoStop;
begin
  Stop :=True;
  if EFD is TEFD_Fiscal then
    AddLog('Processo de geração da EFD-ICMS/IPI paralisado pelo usuário!')
  else
    AddLog('Processo de geração da EFD-Contribuíções paralisado pelo usuário!');
end;

function TBaseLoadEFD.Execute(AFilter: TLoadEFDTFilter): Boolean;
begin
  Filter :=AFilter
  ;
end;

class function TBaseLoadEFD.GetInstance: TBaseLoadEFD;
begin
  if Assigned(Instance) then
    Result :=Instance
  else
    Result :=nil ;
end;

function TBaseLoadEFD.LoadDocFis01: TUniQuery;
begin

  RetCod :=TBaseLoadEFD.COD_LOAD_SUCESS;
  RetMsg :='';

  Result :=TUniQuery.NewQuery();
  Result.sql.Add('--/** EFD00.pas **/                      ');
//    Result.sql.Add('declare @codfil smallint; set @codfil=%d ',[filter.CodEmp]);
//    Result.sql.Add('declare @dtaini datetime; set @dtaini=%s ',[Result.SQLFun.SDatSQL(filter.DtaIni)]);
//    Result.sql.Add('declare @dtafin datetime; set @dtafin=%s ',[Result.SQLFun.SDatSQL(filter.DtaFin,True)]);

  with Result.sql do
  begin
    // ********
    // entradas
    // ********
    if docEnt in filter.DocTyp then
    begin
      Add('select                                                            ');

      Add('  emp.id_filial as emp_codigo,                                    ');
      Add('  emp.nome  as emp_nome   ,                                       ');
      Add('  emp.cnpj  as emp_cnpj   ,                                       ');
      Add('  emp.ie  as emp_ie    ,                                          ');
      Add('  emp.cep as emp_cep   ,                                          ');
      Add('  emp.tipo_logradouro as emp_logr,                                ');
      Add('  emp.logradouro    as emp_endere,                                ');
      Add('  emp.numero    as emp_numero,                                    ');
      Add('  emp.bairro  as emp_bairro,                                      ');
      Add('  emp.tel    as emp_fone  ,                                       ');
      Add('  emp.codigo_municipio as emp_codmun,                             ');
      Add('  emp.uf  as emp_uf,                                              ');

      Add('  par.id_fornecedor as part_cod,                                  ');
      Add('  pes.nome as part_nome    ,                                      ');
      Add('  pes.tipo_pessoa as part_typpes  ,                               ');
      Add('  case when pes.tipo_pessoa=0 then pes.cpf_cnpj end  as part_cpf ,');
      Add('  case when pes.tipo_pessoa=1 then pes.cpf_cnpj end  as part_cnpj,');
      Add('  pes.rg as part_ie      ,                                        ');
      Add('  pes.logradouro   as part_endere  ,                              ');
      Add('  pes.bairro as part_bairro  ,                                    ');
      Add('  mun.codigo_fiscal as part_codmun ,                              ');
      Add('  mun.uf  as part_uf ,                                            ');

      Add('  mov.id_movimento as id_mov,                                     ');
      Add('  mov.tipo_mov  as ind_oper,                                      ');
      Add('  1  as ind_emit,                                                 ');
      Add('  55 as cod_mod ,                                                 ');
      Add('  case mov.cancelado when 1 then 02                               ');
      Add('  else 00 end as cod_sit,                                         ');
      Add('  0  as ser_doc,                                                  ');
      Add('  cast(mov.numero_doc as int) as num_doc,                         ');
      Add('  mov.nfe_chave as chv_nfe,                                       ');
      Add('  mov.dt_emissao as dta_emi ,                                     ');
      Add('  mov.dt_movimento  as dta_e_s    ,                               ');
      Add('  0  as nat_oper ,                                                ');
      Add('  9  as ind_fret,                                                 ');
      Add('  0  as vlr_fret ,                                                ');

      Add('  itm.valor_outras as vlr_out_da,                                 ');
      Add('  itm.valor_desconto as vlr_desc ,                                ');
      Add('  itm.quantidade as qtd_item,                                     ');
      Add('  itm.valor_unitario as vlr_unit,                                 ');
      Add('  case when itm.situacao_tributaria is null then 0                ');
      Add('  else itm.situacao_tributaria end as cst_icms ,                  ');
      Add('  itm.cfop  as cfop ,                                             ');
      Add('  itm.base_icms as vlr_bc_icms,                                   ');
      Add('  itm.percentual_icms as aliq_icms ,                              ');
      Add('  itm.valor_icms  as vlr_icms,                                    ');
      Add('  itm.base_substuicao as vlr_bc_icmsst,                           ');
      Add('  itm.percentual_substituicao as aliq_icmsst ,                    ');
      Add('  itm.valor_substituicao  as vlr_icmsst   ,                       ');
      Add('  itm.percentual_ipi as aliq_ipi     ,                            ');
      Add('  itm.valor_ipi as vlr_ipi      ,                                 ');
      Add('  0.00 as vlr_rbc  ,                                              ');

      Add('  pro.percentual_reducao as aliq_rbc,                             ');
      Add('  pro.id_item  as cod_item     ,                                  ');
      Add('  pro.descricao  as descr_item ,                                  ');
      Add('  pro.cod_barra  as cod_barra ,                                   ');
      Add('  pro.unidade  as unid_inv ,                                      ');
      Add('  pro.ncm as cod_ncm ,                                            ');
      Add('  pro.pis as aliq_pis  ,                                          ');
      Add('  pro.cofins as aliq_cofins                                       ');

      Add('  ,case when pro.classe_pis is null then 99 else pro.classe_pis end as cst_pis           ');
      Add('  ,case when pro.classe_cofins is null then 99 else pro.classe_cofins end as cst_cofins  ');

      Add(' ,%d as cod_gen                                                    ', [TDefValue.COD_GEN_ITEM]);

      Add('from movimento mov                                                ');
      Add('inner join filial emp on emp.id_filial = mov.id_filial            ');
      Add('inner join fornecedor par on par.id_fornecedor = mov.id_fornecedor');
      Add('inner join pessoa pes on pes.id_pessoa         = par.id_pessoa    ');
      Add('inner join municipio mun on mun.id_municipio   = pes.id_municipio ');
      Add('inner join itens_mov itm on itm.id_movimento    = mov.id_movimento');
      Add('left join item pro on pro.id_item              = itm.id_item      ');

      if filter.CodEmp >= 1 then
      begin
        Add('where mov.id_filial =%d                                     ',[Self.filter.CodEmp]);
        Add('and   mov.tipo_mov  =0                                      ');
      end
      else begin
        Add('where mov.tipo_mov  =0                                      ');
      end;

      if filter.DtaTyp = dtEntr then
      begin
        Add('and   mov.dt_movimento between :dt_ini1 and :dt_fin1        ');
      end
      else begin
        Add('and   mov.dt_emissao between :dt_ini1 and :dt_fin1          ');
      end;

      Result.AddParamDat('dt_ini1', Self.filter.DtaIni) ;
      Result.AddParamDat('dt_fin1', Self.filter.DtaFin) ;
    end;
    //
    if filter.DocTyp=[docEnt,docSai] then
    begin
      Add('');
      Add('union all                                                       ');
      Add('');
    end;

    // *****************
    // saidas/devolucoes
    // *****************
    if docSai in filter.DocTyp then
    begin
      Add('select                                                           ');

      Add('  emp.id_filial as emp_codigo,                                   ');
      Add('  emp.nome  as emp_nome   ,                                      ');
      Add('  emp.cnpj  as emp_cnpj   ,                                      ');
      Add('  emp.ie  as emp_ie    ,                                         ');
      Add('  emp.cep as emp_cep   ,                                         ');
      Add('  emp.tipo_logradouro as emp_logr,                               ');
      Add('  emp.logradouro    as emp_endere,                               ');
      Add('  emp.numero    as emp_numero,                                   ');
      Add('  emp.bairro  as emp_bairro,                                     ');
      Add('  emp.tel    as emp_fone  ,                                      ');
      Add('  emp.codigo_municipio as emp_codmun,                            ');
      Add('  emp.uf  as emp_uf                                              ');

      Add('  par.id_cliente as part_cod,                                     ');
      Add('  pes.nome as part_nome    ,                                      ');
      Add('  pes.tipo_pessoa as part_typpes  ,                               ');
      Add('  case when pes.tipo_pessoa=0 then pes.cpf_cnpj end  as part_cpf ,');
      Add('  case when pes.tipo_pessoa=1 then pes.cpf_cnpj end  as part_cnpj,');
      Add('  pes.rg as part_ie      ,                                        ');
      Add('  pes.logradouro   as part_endere  ,                              ');
      Add('  pes.bairro as part_bairro  ,                                    ');
      Add('  mun.codigo_fiscal as part_codmun ,                              ');
      Add('  mun.uf  as part_uf ,                                            ');

      Add('  mov.id_movimento as id_mov,                                     ');
      Add('  mov.tipo_mov  as ind_oper,                                      ');
      Add('  1  as ind_emit,                                                 ');
      Add('  55 as cod_mod ,                                                 ');
      Add('  case mov.nfe_cstat when 100 then 00                             ');
      Add('                     when 101 then 02                             ');
      Add('                     when 102 then 05                             ');
      Add('                     when 110 then 04                             ');
      Add('                     when 204 then 00                             ');
      Add('  else 00 end as cod_sit,                                         ');
      Add('  0  as ser_doc,                                                  ');
      Add('  mov.numero_doc as num_doc,                                      ');
      Add('  mov.nfe_chave as chv_nfe,                                       ');
      Add('  mov.dt_emissao as dta_emi ,                                     ');
      Add('  mov.dt_movimento  as dta_e_s    ,                               ');
      Add('  0  as nat_oper ,                                                ');
      Add('  9  as ind_fret,                                                 ');
      Add('  0  as vlr_fret ,                                                ');

      Add('  itm.valor_outras as vlr_out_da,                                 ');
      Add('  itm.valor_desconto as vlr_desc ,                                ');
      Add('  itm.quantidade as qtd_item,                                     ');
      Add('  itm.valor_unitario as vlr_unit,                                 ');
      Add('  itm.situacao_tributaria as cst_icms ,                           ');
      Add('  itm.cfop  as cfop ,                                             ');
      Add('  itm.base_icms as vlr_bc_icms,                                   ');
      Add('  itm.percentual_icms as aliq_icms ,                              ');
      Add('  itm.valor_icms  as vlr_icms,                                    ');
      Add('  itm.base_substuicao as vlr_bc_icmsst,                           ');
      Add('  itm.percentual_substituicao as aliq_icmsst ,                    ');
      Add('  itm.valor_substituicao  as vlr_icmsst   ,                       ');
      Add('  itm.percentual_ipi as aliq_ipi     ,                            ');
      Add('  itm.valor_ipi as vlr_ipi      ,                                 ');
      Add('  0.00 as vlr_rbc  ,                                              ');

      Add('  pro.percentual_reducao as aliq_rbc,                             ');
      Add('  pro.id_item  as cod_item     ,                                  ');
      Add('  pro.descricao  as descr_item ,                                  ');
      Add('  pro.cod_barra  as cod_barra ,                                   ');
      Add('  pro.unidade  as unid_inv ,                                      ');
      Add('  pro.ncm as cod_ncm ,                                            ');
      Add('  pro.pis as aliq_pis  ,                                          ');
      Add('  pro.cofins as aliq_cofins,                                      ');

      Add('  case when pro.classe_pis_saida is null then 99 else pro.classe_pis_saida end as cst_pis,           ');
      Add('  case when pro.classe_cofins_saida is null then 99 else pro.classe_cofins_saida end as cst_cofins,  ');

      Add(' %d as cod_gen                                                    ', [TDefValue.COD_GEN_ITEM]);

      Add('from movimento mov                                                ');
      Add('inner join filial emp on emp.id_filial = mov.id_filial            ');
      Add('inner join cliente par on par.id_fornecedor = mov.id_cliente ');
      Add('inner join pessoa pes on pes.id_pessoa         = par.id_pessoa    ');
      Add('inner join municipio mun on mun.id_municipio   = pes.id_municipio ');
      Add('inner join itens_mov itm on itm.id_movimento   = mov.id_movimento ');
      Add('left join item pro on pro.id_item              = itm.id_item      ');

      if filter.CodEmp >= 1 then
      begin
        Add('where mov.id_filial =%d                                     ',[Self.filter.CodEmp]);
        Add('and   mov.tipo_mov  =1                                      ');
      end
      else begin
        Add('where mov.tipo_mov  =1                                      ');
      end;
//          if filter.DtaTyp = dtEntr then
//          begin
//            Add('and   mov.dt_movimento between :dt_ini2 and :dt_fin2        ');
//          end
//          else begin
//            Add('and   mov.dt_emissao between :dt_ini2 and :dt_fin2          ');
//          end;
      Add('and   mov.dt_emissao between :dt_ini2 and :dt_fin2            ');
      Result.AddParamDat('dt_ini2', Self.filter.DtaIni) ;
      Result.AddParamDat('dt_fin2', Self.filter.DtaFin) ;
    end;
    //
    Add('order by emp_codigo,                                           ');
    Add('         ind_oper  ,                                           ');
    Add('         num_doc   ,                                           ');
    Add('         cod_item                                              ');
  end;

  try
//      Result.sql.SaveToFile('0.sql');
    Result.Open ;
    if Result.IsEmpty then
    begin
      RetCod :=TBaseLoadEFD.COD_LOAD_MOD55_EMPTY;
      RetMsg :='Nenhum registro encontrado!';
    end;
  except
    on E:EDatabaseError do
    begin
      RetCod :=TBaseLoadEFD.COD_LOAD_ERROR;
      RetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now),E.Message]);
    end;
  end;

  if RetCod in[TBaseLoadEFD.COD_LOAD_SUCESS,TBaseLoadEFD.COD_LOAD_MOD55_EMPTY] then
  try
    femp_codigo :=Result.Field('emp_codigo');
    femp_nome   :=Result.Field('emp_nome') ;
    femp_cnpj   :=Result.Field('emp_cnpj') ;
    femp_ie     :=Result.Field('emp_ie') ;
    femp_cep    :=Result.Field('emp_cep') ;
    femp_endere :=Result.Field('emp_endere');
    femp_bairro :=Result.Field('emp_bairro');
//        femp_ddd    :=Result.Field('emp_ddd') ;
    femp_fone   :=Result.Field('emp_fone') ;
    femp_codmun :=Result.Field('emp_codmun');
    femp_uf     :=Result.Field('emp_uf') ;

    fpart_cod	  :=Result.Field('part_cod') ;
    fpart_nome  :=Result.Field('part_nome');
    fpart_typpes:=Result.Field('part_typpes');
    fpart_cpf   :=Result.Field('part_cpf') ;
    fpart_cnpj  :=Result.Field('part_cnpj');
    fpart_ie    :=Result.Field('part_ie') ;
    fpart_endere:=Result.Field('part_endere');
    fpart_bairro:=Result.Field('part_bairro');
    fpart_codmun:=Result.Field('part_codmun');
    fpart_uf		:=Result.Field('part_uf') ;

    fid_mov	:=Result.Field('id_mov') ;
    find_oper	:=Result.Field('ind_oper') ;
    find_emit	:=Result.Field('ind_emit') ;
    fcod_mod	:=Result.Field('cod_mod') ;
    fcod_sit	:=Result.Field('cod_sit') ;
    fser_doc	:=Result.Field('ser_doc') ;
    fnum_doc	:=Result.Field('num_doc') ;
    fchv_nfe	:=Result.Field('chv_nfe') ;
    fdta_emi	:=Result.Field('dta_emi') ;
    fdta_e_s	:=Result.Field('dta_e_s') ;
    fnat_oper :=Result.Field('nat_oper');

    find_fret :=Result.Field('ind_fret') ;
//        finc_fret :=Result.Field('inc_fret') ;
    fvlr_fret :=Result.Field('vlr_fret') ;
    fvlr_out_da:=Result.Field('vlr_out_da');
    fvlr_desc  :=Result.Field('vlr_desc');
    fqtd_item  :=Result.Field('qtd_item');
    fvlr_unit  :=Result.Field('vlr_unit');
//        fvlr_tot   :=Result.Field('vlr_tot') ;

//        fcls_fis   :=Result.Field('cls_fis');
    fcst_icms  :=Result.Field('cst_icms');
    fcfop   	 :=Result.Field('cfop') ;
    faliq_icms :=Result.Field('aliq_icms');
    fvlr_bc_icms:=Result.Field('vlr_bc_icms');
    fvlr_icms		:=Result.Field('vlr_icms') ;
    fvlr_bc_icmsst:=Result.Field('vlr_bc_icmsst');
    fvlr_icmsst   :=Result.Field('vlr_icmsst') ;
    faliq_ipi     :=Result.Field('aliq_ipi') ;
    fvlr_ipi      :=Result.Field('vlr_ipi') ;
    fvlr_rbc      :=Result.Field('vlr_rbc') ;
    faliq_rbc      :=Result.Field('aliq_rbc') ;

//        fvlr_bc_fret :=Result.Field('vlr_bc_fret') ;
//        fvlr_icmsfret:=Result.Field('vlr_icmsfret') ;

    fcod_item :=Result.Field('cod_item');
    fdescr_item :=Result.Field('descr_item');
    fcod_barra :=Result.Field('cod_barra');
    funid_inv :=Result.Field('unid_inv');
    fcod_ncm :=Result.Field('cod_ncm');
    fcod_gen :=Result.Field('cod_gen');
    faliq_pis :=Result.Field('aliq_pis');
    faliq_cofins :=Result.Field('aliq_cofins');

    fcst_pis :=Result.Field('cst_pis');
    fcst_cofins :=Result.Field('cst_cofins');
  except
    on E:EDatabaseError do
    begin
      RetCod :=TBaseLoadEFD.COD_FIELD_NOT_FOUND;
      RetMsg :=Format('%s|%s',[FormatDateTime('dd/mm/yyyy hh:nn:ss',Now), E.Message]);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'TLoadEFDICMSIPI'}

{ TLoadEFDICMSIPI }

constructor TLoadEFDICMSIPI.Create;
begin
  inherited Create (EFD_Fiscal);
  EFD_Fiscal    :=TEFD_Fiscal.Create ;
  ForceRegC170  :=False;
  AddLog('Iniciou objeto EFD-ICMS/IPI');
end;

destructor TLoadEFDICMSIPI.Destroy;
begin
  AddLog('Finalizou objeto EFD-ICMS/IPI');
  EFD :=nil;
  EFD_Fiscal.Destroy;
  inherited Destroy ;
end;

function TLoadEFDICMSIPI.LoadDocFis01: TUniQuery;
var
  Q: TUniQuery ;
var
  r_C100: ufisbloco_C.Tregistro_C100;
  r_C170: EFDCommon.Tregistro_C170;
  r_C190: ufisbloco_C.Tregistro_C190;

//var
//  ind_ope: TIndTypOper;
//  ind_emi: TIndEmiDoc ;
//  cod_sit: TCodSitDoc ;
//  cod_par: string ;
//  cod_mod: string ;
//  ser_doc: string ;
//  num_doc: Integer;
//  inc_fret:Boolean;
//  chv_nfe: string;
//var
//  cod_item: Integer;
//  und_item: string;
//  vlr_item: Currency;
//  vlr_fret: Currency;
//  vlr_desc: Currency;
//  vlr_out_da: Currency;
//  cst_icms: Word;
//  cfop: Word;
//
//  vbc_icms,
//  aliq_icms,
//  vlr_icms:Currency;
//  vlr_rbc: Currency;
//  vlr_icmsst: Currency;
//  vlr_ipi: Currency;

var //PIS/COFINS
  cst_pis:Word;
  aliq_pis:Currency;
  cst_cofins:Word ;
  aliq_cofins:Currency;
  cls_fis:Byte ;
  vlr_tot:Currency;
  nat_oper: Word ;

var
  codmun: Integer ;

begin
  //
  Stop :=False;

  AddLog('Carregando notas fiscais modelo (01/55/65) de %s',[FormatDateTime('mmm/yyyy', filter.DtaFin)]);
  Q :=inherited LoadDocFis01();
  try
    while not Q.Eof do
    begin

      if Stop then
      begin
        Break;
      end;

      DoInitVars(False);

      // doc´s entradas/saidas
      r_C100 :=EFD_Fiscal.Bloco_C.NewReg_C100(ind_ope,
                                              ind_emi,
                                              part_cod,
                                              cod_mod,
                                              ser_doc,
                                              cod_sit,
                                              num_doc);
      if r_C100.Status = rsNew then
      begin
        r_C100.chv_nfe :=chv_nfe;
        r_C100.dta_emi :=fdta_emi.AsDateTime;
        r_C100.dta_e_s :=fdta_e_s.AsDateTime;
        r_C100.ind_pgto:=tpOut ;
        r_C100.ind_fret:=TIndTypFret(find_fret.AsInteger);
        r_C100.vl_fret :=vlr_fret; //fvlr_fret.AsCurrency;
        r_C100.vl_out_da:=0;//vlr_out_da; //fvlr_out_da.AsCurrency;
        r_C100.vl_desc  :=vlr_desc; //fvlr_desc.AsCurrency;
      end;

      // itens somente para doc regular
      if r_C100.cod_sit=csDocRegular then
      begin
        if not(r_C100.ind_emit=emiProp) then
        begin
          r_C100.ind_pgto :=tpAprz;
        end ;

        if r_C100.ind_emit=emiTerc then
        begin
          r_C170 :=r_C100.registro_C170.AddNew;
          r_C170.nro_item 	 :=r_C100.registro_C170.Count;
          r_C170.cod_item 	 :=fcod_item.AsString	;
          r_C170.descr_compl :=fdescr_item.AsString	;
          r_C170.qtd_item	   :=fqtd_item.AsCurrency	;
          r_C170.und_item	   :=und_item ;
          r_C170.vl_item	   :=vlr_item ;
          r_C170.vl_desc     :=vlr_desc; //fvlr_desc.AsCurrency;
//            if inc_fret then
//            begin
//              r_C170.vl_fret :=vlr_fret; //fvlr_fret.AsCurrency;
//            end;
          r_C170.vl_out_da   :=0; //vlr_out_da; //fvlr_out_da.AsCurrency;
          r_C170.ind_mov	   :=movFis;
          r_C170.cst_icms	   :=cst_icms;
          r_C170.cfop			   :=cfop;
          r_C170.cod_nat	   :='';
          r_C170.vl_bc_icms  :=vbc_icms;
          r_C170.aliq_icms	 :=aliq_icms;
          r_C170.vl_icms     :=vlr_icms;
          r_C170.vl_bc_icmsst:=fvlr_bc_icmsst.AsCurrency;
          r_C170.vl_icmsst   :=vlr_icmsst;
          r_C170.vl_bc_ipi:=vbc_icms;
          r_C170.aliq_ipi	:=faliq_ipi.AsCurrency;
          r_C170.vl_ipi   :=vlr_ipi;

//            if r_C100.ind_oper=toEnt then r_C170.cod_cta :=Self.CodCta_Ent
//            else                          r_C170.cod_cta :=Self.CodCta_Sai;
        end;

        r_C190 :=r_C100.registro_C190.IndexOf(cst_icms, cfop, aliq_icms);
        if r_C190 = nil then
        begin
          r_C190 :=r_C100.registro_C190.AddNew;
          r_C190.cst_icms  :=cst_icms;
          r_C190.cfop		   :=cfop;
          r_C190.per_icms  :=aliq_icms;
          r_C190.vl_oper :=(vlr_item -vlr_desc) +vlr_out_da +vlr_icmsst +vlr_ipi;
//            if inc_fret then
//            begin
//              r_C190.vl_oper :=r_C190.vl_oper +vlr_fret;
//            end;
          r_C190.vl_bc_icms    :=vbc_icms;
          r_C190.vl_icms       :=vlr_icms;
          r_C190.vl_bc_icms_st :=fvlr_bc_icmsst.AsCurrency;
          r_C190.vl_icms_st    :=vlr_icmsst;
          r_C190.vl_rbc        :=vlr_rbc;
          r_C190.vl_ipi        :=vlr_ipi;
        end
        else begin
          r_C190.vl_oper :=r_C190.vl_oper +(vlr_item -vlr_desc) ;
//            if inc_fret then
//            begin
//              r_C190.vl_oper :=r_C190.vl_oper +vlr_fret;
//            end;
          r_C190.vl_oper := r_C190.vl_oper +
                            vlr_out_da+
                            vlr_icmsst+
                            vlr_ipi;
          r_C190.vl_bc_icms		:=r_C190.vl_bc_icms 		+vbc_icms;
          r_C190.vl_icms			:=r_C190.vl_icms				+vlr_icms;
          r_C190.vl_bc_icms_st:=r_C190.vl_bc_icms_st	+fvlr_bc_icmsst.AsCurrency;
          r_C190.vl_icms_st		:=r_C190.vl_icms_st		+vlr_icmsst;
          r_C190.vl_rbc				:=r_C190.vl_rbc				+vlr_rbc;
          r_C190.vl_ipi				:=r_C190.vl_ipi				+vlr_ipi;
        end;
      end;

      Q.Next;
    end;

  finally
    AddLog('%d notas fiscais encontradas.',[Q.RecordCount]);
    Q.Destroy ;
  end;
end;

{$ENDREGION}

begin
  cadcontab00List :=Tcadcontab00List.Create;

end.
