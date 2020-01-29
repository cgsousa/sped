{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              EFD ICMS/IPI & EFD-Contribuições (PIS/Cofins)                  }
{              Copyright (c) 1992,2012 Neway Soft                             }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes e tipos comuns para criacao e gereção dos arquivos  EFD
|   EFD ICMS/IPI & EFD-Contribuições (PIS/Cofins)
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Versão inicial
*}

unit EFDCommon;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ;

{$REGION 'types(Definições)'}
type
  // Versão do Leiaute do arquivo - Tregistro_0000
  TCodVerLay = (//                                          dt_ini    dt_fim
//    cvl100=1,  // Cód.001-Versão 100 Ato COTEPE 01/01/2008  XXXXXXXX  XXXXXXXX
    cvl101=2,  // Cód.002-Versão 101 Ato COTEPE 01/01/2009  01012009  31122009
    cvl102=3,  // Cód.003-Versão 102 Ato COTEPE 01/01/2010  01012010  31122010
    cvl103=4,  // Cód.004-Versão 103 Ato COTEPE 01/01/2011  01012011  31122011
    cvl104=5,  // Cód.005-Versão 104 Ato COTEPE 01/01/2012  01012012  30062012
    cvl105=6,  // Cód.006-Versão 105 Ato COTEPE 01/07/2012  01072012  31122012
    cvl106=7,  // Cód.007                                   01012013  31012013
    cvl107=8,  // Cód.008                                   01012014  31122014
    cvl108=9,  // 009	1.08	01012015	31122015
    cvl109=10, // 010	1.09	01012016	31122016
    cvl110=11, // 011	1.10	01012017	31122017
    cvl111=12, // 012	1.11	01012018	31122018
    cvl112=13, // 013	1.12	01012019	31122019
    cvl113=14  // 014	1.13	01012020
    );

  // Indicador de movimento: 0- Bloco com dados informados, 1- Bloco sem dados informados.
  TIndMov = (movDat, movNoDat) ;

  // Tipo do item
  TItemTyp = (
    itmRevenda , // 00-Mat. para revenda ;
    itmMatPrima, // Materia prima ;
    itmEmbalagm, // Embalagem ;
    itmProdProc, // Produto em processamento;
    itmProdAcab, // Produto acabado ;
    itmSubprod , // Subproduto ;
    itmProdInt, // Produto intermediário ;
    itmMatCons, // Mataerial de cosnumo ;
    itmAtvImob, // Ativo imobilizado ;
    itmServicos, // Serviços ;
    itmOutInsum, // Outros insumos ;
    itmOutros=99 // Outros.
    ) ;

  TIndTypOper =(toEnt, toSai);

  //Indicador do emitente do documento fiscal
  TIndEmiDoc  =(emiProp, emiTerc) ;

  {Indicador do tipo de pagamento:
  	0- À vista;
  	1- A prazo;
  	9- Sem pagamento.
  Obs.: A partir de 01/07/2012 passará a ser:
  Indicador do tipo de pagamento:
  	0- À vista;
  	1- A prazo;
  	2 - Outros}
  TIndTypPgto =(tpAvis, tpAprz, tpOut=2) ;

  //indicador do tipo de frete
  TIndTypFret =(tfTerc, tfEmit, tfDest, tfNone=9);

  //COD_SIT-Situacao do Documento Fiscal
  TCodSitDoc = (
    csDocRegular=00,  //Documento regular
    csEscExtDocRegular=01, //Escrituração extemporânea de documento regular
    csDocCancel=02 ,  //Documento cancelado
    csEscExtDocCancel=03, //Escrituração extemporânea de documento cancelado
    csDocDene=04  ,//NF-e ou CT-e - denegado
    csDocInut=05  ,//NF-e ou CT-e - Numeração inutilizada
    csDocComple=06,//Documento Fiscal Complementar
    csEscExtDocComple=07,//Escrituração extemporânea de documento complementar
    csDocRegEspecial=08 //Documento Fiscal emitido com base em Regime Especial ou Norma Específica}
    );

  //Movimentação física do ITEM/PRODUTO
  TIndMovItem = (movFis, movNone) ;

  //Indicador do tipo de participante (0-Emitente,1-Remetente/Destinatário)
  TIndTypPart =(parEmit, parRemDest);

type
  TDefValue = class
  public
    const ALIQ_PIS=1.65  ;
    const ALIQ_COFINS=7.6;
  public
//    const COD_CTA_DEB_CRE = '000000773';
    const COD_BACEN_BRASIL = 1058 ;
    const COD_GEN_ITEM  = 98;
  end;

  TFileEFD = class(TFileStream)
  public
    constructor Create(const AFileName: string); overload;
    function FOpen: Boolean ;
    procedure NewLine(const S: string) ;
  end;

  TBaseEFDList = class(TObjectList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    procedure DoClear;
    //constructor Create ;
    //destructor Destroy; override ;
  end;

  TRegStatus =(rsRead, rsNew, rsEdit, rsDeleted);
  TBaseRegistro = class
  private
    fReg: string ;
    fStatus: TRegStatus;
  protected
    function GetRow: string; virtual; abstract;
  public
    property Reg: string read FReg; // write FReg;
    property Row: string read GetRow ;
    property Status: TRegStatus read fStatus write fStatus;
    constructor Create(AReg: string); reintroduce ;
  end;

  TOpenBloco = class(TBaseRegistro)
  protected
    Find_mov: TIndMov;
    function GetRow: string; override;
  public
    property ind_mov: TIndMov read Find_mov write Find_mov;
  end;

{$ENDREGION}


{$REGION 'REGISTROS COMUNS DO BLOCO 0 NA EFD FISCAL/PIS-COFINS'}
type

  {$REGION 'REGISTRO 0100: DADOS DO CONTABILISTA'}
  Tregistro_0100 = class(TBaseRegistro)
  protected
    function GetRow: string ; override ;
  public
//    const reg = '0100';
    nome    : string;
    cpf     : string;
    crc     : string;
    cnpj    : string;
    cep     : string;
    endere  : string;
    numero  : string;
    comple  : string;
    bairro  : string;
    fone    : string;
    fax     : string;
    email   : string;
    cod_mun : Integer	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE'}
  Tregistro_0150List = class ;
  Tregistro_0150 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0150List;
  protected
    function GetRow: string; override ;
  public
//    const reg = '0150' 	;
    codigo  :string	;
    nome    :string	;
    cod_pais:Integer;
    cnpj    :string;
    cpf     :string;
    ie      :string;
    cod_mun :Integer;
    suframa :string;
    endere  :string;
    numero  :string;
    comple  :string;
    bairro  :string;
  end	;

  Tregistro_0150List = class (TBaseEFDList)
  private
    function Get(Index: Integer): Tregistro_0150;
  public
    property Items[Index: Integer]: Tregistro_0150 read Get;
    function AddNew: Tregistro_0150;
    function IndexOf(const codigo: string): Tregistro_0150;
//    destructor Destroy; override ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0190: IDENTIFICAÇÃO DAS UNIDADES DE MEDIDA'}
  Tregistro_0190List = class;
  Tregistro_0190 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0190List	;
  protected
    function GetRow: string; override ;
  public
//    const reg = '0190' 	;
    unidad : string	;
    descri : string	;
  end	;

  Tregistro_0190List = class (TBaseEFDList)
  private
    function Get(Index: Integer): Tregistro_0190	;
  public
    property Items[Index: Integer]: Tregistro_0190 read Get;
    function AddNew: Tregistro_0190;
    function IndexOf(const unidad: string): Tregistro_0190;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 0200: TABELA DE IDENTIFICAÇÃO DO ITEM (PRODUTO E SERVIÇOS)'}
  Tregistro_0200List = class;
  Tregistro_0200 = class(TBaseRegistro)
  private
    fOwner: Tregistro_0200List;
  protected
    function GetRow: string; override;
  public
//    codigo: Integer	;
//    descri: string	;
    cod_item: string;
    descr_item: string;
    cod_bar: string	;
    cod_ant: Integer;
    und_iven: string;
    tipo: TItemTyp	;
    cod_ncm: string	;
    cod_ex_ipi: string;
    cod_gen: Integer;
    cod_svc: Word	;
    aliq_icms : Currency;
  end	;

  Tregistro_0200List = class (TBaseEFDList)
  private
    function Get(Index: Integer): Tregistro_0200;
  public
    property Items[Index: Integer]: Tregistro_0200 read Get;
    function AddNew: Tregistro_0200;
    function IndexOf(const cod_item: string): Tregistro_0200;
  end;
  {$ENDREGION}

{$ENDREGION}

{$REGION 'REGISTROS COMUNS DO BLOCO C NA EFD FISCAL/CONTRIBUICOES'}
type
  Tregistro_C100 = class ;
  Tregistro_C170 = class ;
  Tregistro_C170List = class;
  Tregistro_C400 = class ;
  Tregistro_C405 = class;

  {$REGION 'REGISTRO C100: DOCUMENTO - NOTA FISCAL (CÓDIGO 01), NOTA FISCAL AVULSA (CÓDIGO 1B),
  NOTA FISCAL DE PRODUTOR (CÓDIGO 04) e NF-e (CÓDIGO 55)'}
  Tregistro_C100 = class(TBaseRegistro)
  protected
    fvl_desc: Currency ;
    fvl_fret: Currency ;
    fvl_out_da:Currency;
    function getVlDoc: Currency; virtual;
    function getDesc: Currency ; virtual;
    function getFret: Currency ; virtual;
    function getOutDa: Currency; virtual;
    function GetRow: string; override;
  public
    ind_oper:TIndTypOper;
    ind_emit:TIndEmiDoc ;
    cod_part:string	;
    cod_mod	:string	;
    cod_sit	:TCodSitDoc;
    ser_doc	:string	;
    num_doc	:Integer;
    chv_nfe	:string	;
    dta_emi	:TDateTime;
    dta_e_s	:TDateTime;
    ind_pgto:TIndTypPgto;
//    vlr_abat_nt:Currency;
    ind_fret: TIndTypFret;
    vl_seg: Currency	;
    vl_pisst:Currency	;
    vl_cofinsst:Currency;
  public
    property vl_doc: Currency read getVlDoc ;
    property vl_desc: Currency read getDesc write fvl_desc;
    property vl_fret: Currency read getFret write fvl_fret;
    property vl_out_da: Currency read getOutDa write fvl_out_da;
    function vl_merc: Currency; virtual;
    function vl_abat_nt: Currency; virtual;
    function vl_bc_icms: Currency; virtual;
    function vl_icms: Currency; virtual;
    function vl_bc_icmsst: Currency; virtual;
    function vl_icmsst: Currency; virtual;
    function vl_ipi: Currency; virtual;
    function vl_pis:Currency ; virtual;
    function vl_cofins: Currency; virtual;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C170: COMPLEMENTO DO DOCUMENTO - ITENS DO DOCUMENTO (CÓDIGOS 01, 1B, 04 e 55)'}
  Tregistro_C170 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C170List;
  protected
    function GetRow: string; override;
  public
    nro_item     :Integer	; //Número sequencial do item no documento fiscal
    cod_item     :string; //Código do item (campo 02 do Registro 0200)
    descr_compl  :string;   //Descrição complementar do item como adotado no documento fiscal
    qtd_item     :Currency; //Quantidade do item
    und_item     :string	; //Unidade do item (Campo 02 do registro 0190)
    vl_item      :Currency; //Valor total do item (mercadorias ou serviços)
    vl_desc      :Currency; //Valor do desconto comercial
    ind_mov      :TIndMovItem;//Movimentação física do ITEM/PRODUTO:
    // ICMS
    cst_icms     :Integer	; //Código da Situação Tributária referente ao ICMS, conforme a Tabela indicada no item 4.3.1
    cfop         :Integer	;
    cod_nat      :String	;
    vl_bc_icms	 :Currency;
    aliq_icms    :Currency;
    vl_icms      :Currency;
    vl_bc_icmsst :Currency;
    aliq_icmsst  :Currency;
    vl_icmsst    :Currency;
    // IPI
    ind_apur     :string	;
    cst_ipi      :string	;
    cod_enq      :string	;
    vl_bc_ipi    :Currency;
    aliq_ipi     :Double 	;
    vl_ipi       :Currency;
    // PIS
    cst_pis      :Word;
    vl_bc_pis    :Currency;
    aliq_pis     :Currency;
    qtd_bc_pis   :Currency;
    aliq_pis_qtd :Currency;
    // COFINS
    cst_cofins   :Word;
    vl_bc_cofins :Currency;
    aliq_cofins  :Currency;
    qtd_bc_cofins:Currency;
    aliq_cofins_qtd:Currency;
    //
    cod_cta: string;
  public
    // campos somente para calc, não existe no layout!
    vl_fret: Currency ;
    vl_out_da:Currency;
  public
    function vl_pis   :Currency;
    function vl_cofins:Currency;
  end;

  Tregistro_C170List = class (TBaseEFDList)
  private
//    fOwner: Tregistro_C100;
    function Get(Index: Integer): Tregistro_C170 ;
  public
    property Items[Index: Integer]: Tregistro_C170 read Get;
    function AddNew: Tregistro_C170;
    function IndexOf(const nro_item: Integer): Tregistro_C170;
//    constructor Create(AOwner: Tregistro_C100) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C400 - EQUIPAMENTO ECF (CÓDIGO 02 e 2D)'}
  Tregistro_C400 = class(TBaseRegistro)
  protected
    function GetRow: string; override;
  public
    cod_mod: string	;
    ecf_mod: string	;
    ecf_fab: string	;
    ecf_cx : Integer;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C405: REDUÇÃO Z (CÓDIGO 02, 2D e 60)'}
  Tregistro_C405 = class(TBaseRegistro)
  protected
    function GetRow: string; override;
  public
    dt_doc: TDateTime ;
    cro: Integer ;
    crz: Integer ;
    num_coo_fin: Integer;
    gt_fin: Currency ;
    vl_brt: Currency ;
  end;

  {$ENDREGION}

{$ENDREGION}

{$REGION 'BLOCO 9: CONTROLE E ENCERRAMENTO DO ARQUIVO DIGITAL'}
type
  {Este bloco representa os totais de registros e serve como forma de controle
  para batimentos e verificações.}

  TBloco_9 = class;
  Tregistro_9900List = class;

  {$REGION 'REGISTRO 9001: ABERTURA DO BLOCO 9'}
  Tregistro_9001 = class(TOpenBloco)
  private
    fOwner: TBloco_9	;
  protected
    function GetRow: string; override ;
  public
    registro_9900: Tregistro_9900List ;
    constructor Create(AOwner: TBloco_9) ;
    destructor Destroy; override ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 9900: REGISTROS DO ARQUIVO'}
  //Todos os registros referenciados neste arquivo, inclusive os posteriores a
  //este registro, devem ter uma linha totalizadora do seu número de ocorrências
  Tregistro_9900 = class(TBaseRegistro)
  private
    fOwner: Tregistro_9900List	;
  protected
    function GetRow: string; override ;
  public
    reg_bloco    : string;
    qtd_reg_bloco: Integer;
  end	;

  Tregistro_9900List = class(TBaseEFDList)
  private
    fOwner: Tregistro_9001	;
    function Get(Index: Integer): Tregistro_9900	;
  public
    property Items[Index: Integer]: Tregistro_9900 read Get;
    constructor Create(AOwner: Tregistro_9001);
    function AddNew: Tregistro_9900;
    function IndexOf(const reg_bloco: string): Tregistro_9900;
    function Total: Integer	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 9990: ENCERRAMENTO DO BLOCO 9'}
  Tregistro_9990 = class(TBaseRegistro)
  private
    fOwner: TBloco_9;
  protected
    function GetRow: string; override;
  public
    qtd_lin_B9: Integer;
    constructor Create(AOwner: TBloco_9);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 9999: ENCERRAMENTO DO ARQUIVO DIGITAL'}
  Tregistro_9999 = class(TBaseRegistro)
  private
    fOwner: TBloco_9 ;
  protected
    function GetRow: string; override;
  public
    qtd_lin : Integer	;
    constructor Create(AOwner: TBloco_9) ;
  end;
  {$ENDREGION}

  TBloco_9 = class
  private
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_9001 : Tregistro_9001;
    registro_9990 : Tregistro_9990;
    registro_9999 : Tregistro_9999;
  public
    constructor Create;
    destructor	Destroy; override	;
    procedure UpdateReg(const reg_bloco: String; const qtd_lin: Integer=1);
    procedure DoExec(AFile: TFileEFD);
  end;

{$ENDREGION}

type
  TBaseEFD = class
  private
    fFileName: TFileName;
    fFileEFD: TFileEFD;
  private
    fCodVerLay: TCodVerLay;
    fDatIni: TDateTime;
    fDatFin: TDateTime;
//    fCodCta_Ent: string;
//    fCodCta_Sai: string;
  public
    property CodVerLay: TCodVerLay read fCodVerLay; // write fCodVerLay;
    property DatIni: TDateTime read fDatIni write fDatIni;
    property DatFin: TDateTime read fDatFin write fDatFin;
//    property CodCta_Ent: string read fCodCta_Ent write fCodCta_Ent;
//    property CodCta_Sai: string read fCodCta_Sai write fCodCta_Sai;
  public
    property FileName: TFileName read fFileName; // write fFileName;
    property FileEFD: TFileEFD read fFileEFD ;
  public
    function Execute(AFileName: TFileName): Boolean; virtual;
  end;

implementation

uses
  EFDUtils
  ;

{ TFileEFD }

constructor TFileEFD.Create(const AFileName: string);
begin
    inherited Create(AFileName, fmCreate or fmShareDenyWrite);

end;

function TFileEFD.FOpen: Boolean;
begin
    try
      	inherited Create(Self.FileName, fmOpenWrite or fmShareDenyWrite);
        Result :=True ;
    except
      	Result :=False ;
    end;
end;

procedure TFileEFD.NewLine(const S: string);
var
//    NL: string ;
  NL: TStringStream ;
begin
//    NL :=S +#13#10 ;
//    Self.WriteBuffer(NL[1], Length(NL));
    NL :=TStringStream.Create(S +#13#10) ;
    try
      Self.CopyFrom(NL, NL.Size) ;
    finally
      NL.Free ;
    end;
end;

{ TBaseRegistro }

constructor TBaseRegistro.Create(AReg: string);
begin
    inherited Create();
    fReg    :=AReg ;
    fStatus :=rsNew ;
end;

{ TOpenBloco }

function TOpenBloco.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.Reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0');
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{$REGION 'BLOCO 9: CONTROLE E ENCERRAMENTO DO ARQUIVO DIGITAL'}

{ TBloco_9 }

constructor TBloco_9.Create;
begin
    inherited Create;
    registro_9001 :=Tregistro_9001.Create(Self) ;
    registro_9990 :=Tregistro_9990.Create(Self) ;
    registro_9999 :=Tregistro_9999.Create(Self) ;
end;

destructor TBloco_9.Destroy;
begin
    registro_9001.Destroy;
    registro_9990.Destroy;
    registro_9999.Destroy;
    inherited Destroy ;
end;

procedure TBloco_9.DoExec(AFile: TFileEFD);
var
  r_9900: Tregistro_9900 ;
var
    I:Integer;
begin
    AFile.NewLine(registro_9001.Row);

    UpdateReg(registro_9990.Reg, 1);
    UpdateReg(registro_9999.Reg, 1);

    r_9900 :=registro_9001.registro_9900.AddNew ;
    r_9900.reg_bloco 		:=r_9900.Reg;
    r_9900.qtd_reg_bloco:=registro_9001.registro_9900.Count ;

    for I :=0 to registro_9001.registro_9900.Count -1 do
    begin
        AFile.NewLine(registro_9001.registro_9900.Items[I].Row);
    end;

    AFile.NewLine(registro_9990.Row);
    AFile.NewLine(registro_9999.Row);
end;

procedure TBloco_9.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_9990.qtd_lin_B9, qtd_lin) ;
end;

procedure TBloco_9.UpdateReg(const reg_bloco: String; const qtd_lin: Integer=1);
var
    reg: Tregistro_9900;
begin
    reg :=Self.registro_9001.registro_9900.IndexOf(reg_bloco) ;
    if reg = nil then
    begin
        reg :=Self.registro_9001.registro_9900.AddNew ;
        reg.reg_bloco :=reg_bloco ;
        reg.qtd_reg_bloco :=qtd_lin;
    end
    else
    begin
        Inc(reg.qtd_reg_bloco, qtd_lin);
    end;
end;

{ Tregistro_9001 }

constructor Tregistro_9001.Create(AOwner: TBloco_9);
begin
    inherited Create('9001');
    fOwner :=AOwner;
    ind_mov:=movDat;
    registro_9900 :=Tregistro_9900List.Create(Self);
end;

destructor Tregistro_9001.Destroy;
begin
    registro_9900.Destroy ;
    inherited Destroy;
end;

function Tregistro_9001.GetRow: string;
begin
    Result :=inherited GetRow ;
    fOwner.DoInc();
    fOwner.UpdateReg(Self.reg);
end;

{ Tregistro_9900List }

function Tregistro_9900List.AddNew: Tregistro_9900;
begin
    Result        :=Tregistro_9900.Create('9900');
    Result.fOwner	:=Self;
    inherited Add(Result);
end;

constructor Tregistro_9900List.Create(AOwner: Tregistro_9001);
begin
    inherited Create;
    fOwner :=AOwner;
end;

function Tregistro_9900List.Get(Index: Integer): Tregistro_9900;
begin
  	Result:=Tregistro_9900(inherited Items[Index]);
end;

function Tregistro_9900List.IndexOf(const reg_bloco: string): Tregistro_9900;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if Self.Items[I].reg_bloco=reg_bloco then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

function Tregistro_9900List.Total: Integer;
var
    I:Integer;
begin
    Result:=0;
    for I :=0 to Self.Count -1 do
    begin
    		Result  :=Result + Self.Items[I].qtd_reg_bloco;
    end;
end;

{ Tregistro_9900 }

function Tregistro_9900.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg_bloco,4);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_reg_bloco);
    Result  :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fOwner.fOwner.DoInc();
end;

{ Tregistro_9990 }

constructor Tregistro_9990.Create(AOwner: TBloco_9);
begin
    inherited Create('9990');
    fOwner :=AOwner;
end;

function Tregistro_9990.GetRow: string;
begin
    Inc(Self.qtd_lin_B9, 2);
  	Result  :=        Tefd_util.SEP_FIELD +Self.reg;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_B9);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_9999 }

constructor Tregistro_9999.Create(AOwner: TBloco_9);
begin
    inherited Create('9999');
    fOwner :=AOwner;
end;

function Tregistro_9999.GetRow: string;
begin
    Self.qtd_lin :=fOwner.registro_9001.registro_9900.Total	;
  	Result  :=        Tefd_util.SEP_FIELD +Self.reg;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

{$ENDREGION}

{ Tregistro_0100 }

function Tregistro_0100.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nome,100);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cpf,11,True);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.crc,15);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14,True);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cep,8);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.endere,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.numero,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.comple,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.bairro,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.fone,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.fax,10);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.email,100);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_mun,7) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_0150List }

function Tregistro_0150List.AddNew: Tregistro_0150;
begin
    Result  :=Tregistro_0150.Create('0150') ;
    Result.fOwner :=Self  ;
    Result.Status:=rsNew ;
    inherited Add(Result) ;
end;

function Tregistro_0150List.Get(Index: Integer): Tregistro_0150;
begin
    Result :=Tregistro_0150(inherited Items[Index]) ;
end;

function Tregistro_0150List.IndexOf(const codigo: string): Tregistro_0150;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].codigo=codigo then
        begin
            Result :=Self.Items[I];
            Result.Status :=rsRead ;
            Break ;
        end;
    end;
end;

{ Tregistro_0150 }

function Tregistro_0150.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.codigo; //Tefd_util.FStr(Self.codigo,8) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nome,100) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_pais,5) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cpf,11) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ie,14) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_mun,7) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.suframa,9) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.endere,60) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.numero,10) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.comple,60) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.bairro,60) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_0190List }

function Tregistro_0190List.AddNew: Tregistro_0190;
begin
    Result :=Tregistro_0190.Create('0190') ;
    Result.fOwner:=Self  ;
    Result.Status:=rsNew ;
    inherited Add(Result) ;
end;

function Tregistro_0190List.Get(Index: Integer): Tregistro_0190;
begin
    Result :=Tregistro_0190(inherited Items[Index]) ;
end;

function Tregistro_0190List.IndexOf(const unidad: string): Tregistro_0190;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].unidad=unidad then
        begin
            Result :=Self.Items[I] ;
            Result.Status:=rsRead;
            Break ;
        end;
    end;
end;

{ Tregistro_0190 }

function Tregistro_0190.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.unidad,6) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descri,30) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_0200List }

function Tregistro_0200List.AddNew: Tregistro_0200;
begin
    Result :=Tregistro_0200.Create('0200') ;
    Result.fOwner :=Self ;
    Result.Status:=rsNew ;
    inherited Add(Result);
end;

function Tregistro_0200List.Get(Index: Integer): Tregistro_0200;
begin
    Result :=Tregistro_0200(inherited Items[Index]) ;
end;

function Tregistro_0200List.IndexOf(const cod_item: string): Tregistro_0200;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cod_item=cod_item then
        begin
            Result :=Self.Items[I] ;
            Result.Status :=rsRead ;
            Break ;
        end;
    end;
end;


{ Tregistro_0200 }

function Tregistro_0200.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_item);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descr_item,60);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_bar) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_ant) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.und_iven,6) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.tipo),2,'00');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_ncm,8) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_ex_ipi,3) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_gen,2,'98');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_svc,3) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.aliq_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ TBaseEFD }

function TBaseEFD.Execute(AFileName: TFileName): Boolean;
var
  Path: string ;
begin
  fFileName :=AFileName ;
  Path :=ExtractFilePath(fFileName) ;
  if Path<>'' then
  begin
    Path :=ExcludeTrailingPathDelimiter(Path);
    if not DirectoryExists(Path) then
    begin
      ForceDirectories(Path) ;
    end;
    fFileName :=ExtractFileName(fFileName);
    fFileName :=Path +'\'+ fFileName ;
  end;
  try
    fFileEFD :=TFileEFD.Create(fFileName);
    Result   :=True;
  except
    Result :=False;
  end;
end;

{$REGION 'REGISTROS COMUNS DO BLOCO 0 NA EFD FISCAL/PIS-COFINS'}
{ Tregistro_D100List }
(*
function Tregistro_D100List.AddNew: Tregistro_D100;
begin
    Result :=Tregistro_D100.Create  ;
    Result.fOwner :=Self  ;
    inherited Add(Result) ;
end;

function Tregistro_D100List.Get(Index: Integer): Tregistro_D100;
begin
    Result :=Tregistro_D100(inherited Items[Index]) ;
end;

function Tregistro_D100List.IndexOf(const ind_emit: TIndEmiDoc ;
                                    const num_doc: Integer;
                                    const cod_mod: string ;
                                    const ser_doc: string ;
                                    const sub_ser: string ;
                                    const cod_part: string): Tregistro_D100;
var
    I:Integer;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I];
        if(Result.ind_emit =ind_emit)and
          (Result.num_doc  =num_doc )and
          (Result.cod_mod  =cod_mod )and
          (Result.ser_doc  =ser_doc )and
          (Result.sub_ser  =sub_ser )then
          //(Result.cod_part =cod_part)then
        begin
            Result.Status :=rsRead ;
            Break ;
        end
        else
        begin
            Result :=nil ;
        end;
    end;
end;

{ Tregistro_D100 }

constructor Tregistro_D100.Create;
begin

end;

function Tregistro_D100.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_oper));
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_emit));
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_part ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_mod  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_sit),2) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ser_doc,4) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.sub_ser,3) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.num_doc,9) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.chv_cte  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_doc) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_a_p) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.typ_cte  ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.chv_cte_ref  ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_doc,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_desc) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_fret)) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_serv,'0') ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_bc_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_nt_icms) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_inf  ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta  ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;
*)
{$ENDREGION}

{ TBaseEFDList }

procedure TBaseEFDList.DoClear;
var
  	I: Integer;
    O: TObject;
begin
    for I :=0 to Self.Count -1 do
    begin
        O :=Self.Items[I];
        if O is TBaseEFDList then
        begin
          	TBaseEFDList(O).Clear;
        end
        else begin
        		FreeAndNil(O);
        end;
    end;
    inherited Clear;
end;

procedure TBaseEFDList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  	inherited Notify(Ptr, Action);

end;

{ Tregistro_C100 }

function Tregistro_C100.getDesc: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.getFret: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.getOutDa: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_oper),1,'0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_emit),1,'0');
    if Self.cod_sit<>csDocRegular then
    begin
    		Result	:=Result +Tefd_util.SEP_FIELD ;
    end
    else begin
    		Result	:=Result +Tefd_util.SEP_FIELD +Self.cod_part; //Tefd_util.FStr(Self.cod_part,10);
    end;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_mod,2);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_sit),2,'00');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ser_doc,3);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.num_doc,8);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.chv_nfe,44);
    if Self.cod_sit<>csDocRegular then
    begin
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
        Result  :=Result +Tefd_util.SEP_FIELD;
    end
    else begin
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_emi);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_e_s);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_doc);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_pgto),1,'0');
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_desc);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_abat_nt);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_merc,'0');
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_fret),1,'1');
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_fret);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_seg);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_out_da);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icms);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icms);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icmsst);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icmsst);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ipi);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pisst);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofinsst);
        Result  :=Result +Tefd_util.SEP_FIELD ;
    end;
end;

function Tregistro_C100.getVlDoc: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_abat_nt: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_bc_icms: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_bc_icmsst: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_cofins: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_icms: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_icmsst: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_ipi: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_merc: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_pis: Currency;
begin
  Result :=0;
end;

{ Tregistro_C170List }

function Tregistro_C170List.AddNew: Tregistro_C170;
begin
    Result :=Tregistro_C170.Create('C170');
    Result.fOwner :=Self  ;
    inherited Add(Result) ;
end;

{constructor Tregistro_C170List.Create(AOwner: Tregistro_C100);
begin
    inherited Create;
    fOwner :=AOwner ;
end;}

function Tregistro_C170List.Get(Index: Integer): Tregistro_C170;
begin
    Result :=Tregistro_C170(inherited Items[Index]) ;
end;

function Tregistro_C170List.IndexOf(const nro_item: Integer): Tregistro_C170;
var
    I:Integer ;
begin
    Result :=nil  ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].nro_item =nro_item then
        begin
            Result :=Self.Items[I] ;
        end;
    end;
end;


{ Tregistro_C170 }

function Tregistro_C170.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.nro_item,03);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_item);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descr_compl,60);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_item,'0.000','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.und_item,06);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_desc);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_icms,3,'000');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_nat,4,True);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icms);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.aliq_icms,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icms);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_icmsst);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_icmsst,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_icmsst);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ind_apur,1,True,'0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cst_ipi,2);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_enq,3);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_ipi);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_ipi,'0,00');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_ipi);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_pis,2);
    if not(Self.cst_pis in[98,99]) then
    begin
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_pis,'0');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis,'0.0000','0');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_bc_pis,'0.000');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.aliq_pis_qtd);
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis,'0');
    end
    else
    begin
        Result	:=Result +Tefd_util.SEP_FIELD;
        Result	:=Result +Tefd_util.SEP_FIELD;
        Result	:=Result +Tefd_util.SEP_FIELD;
        Result	:=Result +Tefd_util.SEP_FIELD;
        Result	:=Result +Tefd_util.SEP_FIELD;
    end;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_cofins,2);
    if not(Self.cst_cofins in[98,99]) then
    begin
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_cofins,'0');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins,'0.0000','0');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_bc_cofins,'0.000');
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.aliq_cofins_qtd);
        Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins,'0');
    end
    else
    begin
        Result	:=Result +Tefd_util.SEP_FIELD ;
        Result	:=Result +Tefd_util.SEP_FIELD ;
        Result	:=Result +Tefd_util.SEP_FIELD ;
        Result	:=Result +Tefd_util.SEP_FIELD ;
        Result	:=Result +Tefd_util.SEP_FIELD ;
    end;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_cta,8,True);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_C170.vl_cofins: Currency;
begin
    Result :=(Self.vl_bc_cofins *Self.aliq_cofins)/100 ;
    Result :=StrToCurr(Tefd_util.FCur(Result, '0'));
end;

function Tregistro_C170.vl_pis: Currency;
begin
    Result :=(Self.vl_bc_pis *Self.aliq_pis)/100 ;
    Result :=StrToCurr(Tefd_util.FCur(Result, '0'));
end;

function Tregistro_C400.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.Reg) ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_mod,2);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ecf_mod,20);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ecf_fab,20);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.ecf_cx,3);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C405 }

function Tregistro_C405.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.Reg) ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_doc);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cro,3);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.crz,6);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.num_coo_fin,6);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.gt_fin);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_brt,'0');
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

end.
