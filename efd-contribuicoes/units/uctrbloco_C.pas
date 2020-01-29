{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              EFD-Contribuições                                              }
{              BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI)         }
{              Copyright (c) 1992,2012 Suporteware                            }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o Bloco C da
|   EFD-Contribuições (PIS/COFINS)
|
|Historico  Descrição
|******************************************************************************
|16.08.2012 Cada bloco possui sua unit(antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}

unit uctrbloco_C;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI)'}
type
  TBloco_C = class;
  Tregistro_C010List = class;
  Tregistro_C100List = class;
  Tregistro_C170List = class;
  Tregistro_C180List = class;
  Tregistro_C181List = class;
  Tregistro_C185List = class;
//  Tregistro_C190List = class;
//  Tregistro_C191List = class;
//  Tregistro_C195List = class;
  Tregistro_C400List = class;
  Tregistro_C405List = class;
  Tregistro_C481List = class;
  Tregistro_C485List = class;

  {$REGION 'REGISTRO C001: ABERTURA DO BLOCO C'}
  Tregistro_C001 = class(TOpenBloco)
  private
    fOwner: TBloco_C;
  protected
    function GetRow: string; override;
  public
    registro_C010: Tregistro_C010List ;
    constructor Create(AOwner: TBloco_C);
    destructor Destroy; override;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C010: IDENTIFICAÇÃO DO ESTABELECIMENTO'}
  Tregistro_C010 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C010List;
  protected
    function GetRow: string; override;
  public
    cnpj: string  ;
    ind_escri: string ;
  public
    registro_C100: Tregistro_C100List;
    registro_C400: Tregistro_C400List;
    constructor Create;
    destructor Destroy; override;
  end;

  Tregistro_C010List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C001;
    function Get(Index: Integer): Tregistro_C010 ;
  public
    property Items[Index: Integer]: Tregistro_C010 read Get;
    constructor Create(AOwner: Tregistro_C001);
    function AddNew: Tregistro_C010;
    function IndexOf(const cnpj: string): Tregistro_C010;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C100: DOCUMENTO - NOTA FISCAL (CÓDIGO 01), NOTA FISCAL AVULSA (CÓDIGO 1B),
  NOTA FISCAL DE PRODUTOR (CÓDIGO 04) e NF-e (CÓDIGO 55)'}
  Tregistro_C100 = class(EFDCommon.Tregistro_C100)
  private
    fOwner: Tregistro_C100List ;
  protected
    function getVlDoc: Currency; override ;
    function getDesc: Currency ; override ;
    function getFret: Currency ; override ;
    function getOutDa: Currency; override ;
    function vl_merc: Currency;  override ;
    function vl_abat_nt: Currency; override ;
    function vl_bc_icms: Currency; override ;
    function vl_icms: Currency; override ;
    function vl_bc_icmsst: Currency; override ;
    function vl_icmsst: Currency; override ;
    function vl_ipi: Currency; override ;
    function vl_pis:Currency; override ;
    function vl_cofins: Currency; override ;
  public
    registro_C170: Tregistro_C170List ;
    constructor Create;
    destructor Destroy; override ;
  end;

  Tregistro_C100List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C010 ;
    function Get(Index: Integer): Tregistro_C100 ;
  public
    property Items[Index: Integer]: Tregistro_C100 read Get;
    constructor Create(AOwner: Tregistro_C010);
    function AddNew: Tregistro_C100;
    function IndexOf(const ind_oper:TIndTypOper;
                     const ind_emit:TIndEmiDoc ;
                     const cod_part:string ;
                     const cod_mod,ser_doc:string;
                     const cod_sit:TCodSitDoc ;
                     const num_doc: Integer): Tregistro_C100;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C170: COMPLEMENTO DO DOCUMENTO - ITENS DO DOCUMENTO (CÓDIGOS 01, 1B, 04 e 55)'}
  {Tregistro_C170 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C170List;
    fIndex: Integer  ;
  public
    nro_item       :Integer	; //Número sequencial do item no documento fiscal
    cod_item       :Integer	; //Código do item (campo 02 do Registro 0200)
    descr_compl    :string;   //Descrição complementar do item como adotado no documento fiscal
    qtd_item       :Currency; //Quantidade do item
    und_item       :string	; //Unidade do item (Campo 02 do registro 0190)
    vl_item       :Currency; //Valor total do item (mercadorias ou serviços)
    vl_desc       :Currency; //Valor do desconto comercial
    ind_mov        :TIndMovItem;//Movimentação física do ITEM/PRODUTO:
    // ICMS
    cst_icms       :Integer	; //Código da Situação Tributária referente ao ICMS, conforme a Tabela indicada no item 4.3.1
    cfop           :Integer	;
    cod_nat        :String	;
    vl_bc_icms		 :Currency;
    aliq_icms      :Currency;
    vl_icms       :Currency;
    vl_bc_icmsst  :Currency;
    aliq_icmsst    :Currency;
    vl_icmsst     :Currency;
    // IPI
    ind_apur       :string	;
    cst_ipi        :string	;
    cod_enq        :string	;
    vl_bc_ipi     :Currency;
    aliq_ipi       :Double 	;
    vl_ipi        :Currency;
    // PIS
    cst_pis        :Word;
    vl_bc_pis     :Currency;
    aliq_pis       :Currency;
    qtd_bc_pis   	 :Currency;
    aliq_pis_qtd   :Currency;
    // COFINS
    cst_cofins     :Word	;
    vl_bc_cofins  :Currency;
    aliq_cofins    :Currency;
    qtd_bc_cofins	 :Currency;
    aliq_cofins_qtd:Currency;
    //
    cod_cta        :string;
  protected
    function GetRow: string; override;
  public
    // campos somente para calc não pertencente ao layout
    vl_fret: Currency ;
    vl_out_da:Currency ;
  public
    function vl_pis   :Currency;
    function vl_cofins:Currency;
  end;}

  //Tregistro_C170List = class (TBaseEFDList)
  Tregistro_C170List = class (EFDCommon.Tregistro_C170List)
  private
    fOwner: Tregistro_C100 ;
    //function Get(Index: Integer): Tregistro_C170 ;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    {property Items[Index: Integer]: Tregistro_C170 read Get;
    function AddNew: Tregistro_C170;
    function IndexOf(const nro_item: Integer): Tregistro_C170;}
    constructor Create(AOwner: Tregistro_C100) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C180: CONSOLIDAÇÃO DE NOTAS FISCAIS ELETRÔNICAS EMITIDAS PELA PESSOA JURÍDICA
  (CÓDIGO 55) – OPERAÇÕES DE VENDAS'}
  Tregistro_C180 = class
  private
    fOwner: Tregistro_C180List;
  public
    const reg = 'C180';
    const cod_mod = '55';
  public
    dt_doc_ini: TDateTime;
    dt_doc_fin: TDateTime;
    cod_item: Integer ;
    cod_ncm: string ;
    ex_ipi: string ;
    vl_tot_item: Currency;
    function Row: string ;
  public
    registro_C181: Tregistro_C181List;
    registro_C185: Tregistro_C185List;
    constructor Create ;
    destructor Destroy ; override ;
  end;

  Tregistro_C180List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C010;
    function Get(Index: Integer): Tregistro_C180 ;
  public
    property Items[Index: Integer]: Tregistro_C180 read Get;
    function AddNew: Tregistro_C180;
    function IndexOf(const cod_item: Integer): Tregistro_C180;
    constructor Create(AOwner: Tregistro_C010) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C181: DETALHAMENTO DA CONSOLIDAÇÃO – OPERAÇÕES DE VENDAS – PIS/PASEP'}
  Tregistro_C181 = class
  private
    const reg = 'C181';
  private
    fOwner: Tregistro_C181List;
  public
    cst_pis: Word ;
    cfop: Word ;
    vl_item: Currency ;
    vl_desc: Currency ;
    vl_bc_pis: Currency ;
    aliq_pis: Currency ;
    qtd_bc_pis: Currency;
    aliq_pis_qtd: Currency ;
    vl_pis: Currency ;
    cod_cta: string ;
    function Row: string ;
  end;

  Tregistro_C181List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C180 ;
    function Get(Index: Integer): Tregistro_C181 ;
  public
    property Items[Index: Integer]: Tregistro_C181 read Get;
    function AddNew: Tregistro_C181;
    function IndexOf(const cst_pis, cfop: Word; const aliq_pis: Currency): Tregistro_C181;
    constructor Create(AOwner: Tregistro_C180) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C185: DETALHAMENTO DA CONSOLIDAÇÃO – OPERAÇÕES DE VENDAS – COFINS'}
  Tregistro_C185 = class
  private
    const reg = 'C185';
  private
    fOwner: Tregistro_C185List;
  public
    cst_cofins: Word ;
    cfop: Word ;
    vl_item: Currency ;
    vl_desc: Currency ;
    vl_bc_cofins: Currency ;
    aliq_cofins: Currency ;
    qtd_bc_cofins: Currency;
    aliq_cofins_qtd: Currency ;
    vl_cofins: Currency ;
    cod_cta: string ;
    function Row: string ;
  end;

  Tregistro_C185List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C180 ;
    function Get(Index: Integer): Tregistro_C185 ;
  public
    property Items[Index: Integer]: Tregistro_C185 read Get;
    function AddNew: Tregistro_C185;
    function IndexOf(const cst_cofins, cfop: Word; const aliq_cofins: Currency): Tregistro_C185;
    constructor Create(AOwner: Tregistro_C180) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C190: CONSOLIDAÇÃO DE NOTAS FISCAIS ELETRÔNICAS (CÓDIGO 55) – OPERAÇÕES DE
  AQUISIÇÃO COM DIREITO A CRÉDITO, E OPERAÇÕES DE DEVOLUÇÃO DE COMPRAS E VENDAS'}
  {Tregistro_C190 = class
  private
    fOwner: Tregistro_C190List;
  public
    const reg = 'C190';
  public
    cod_mod: string;
    dt_doc_ini: TDateTime;
    dt_doc_fin: TDateTime;
    cod_item: Integer ;
    cod_ncm: string ;
    ex_ipi: string ;
    vl_tot_item: Currency;
    function Row: string ;
  public
    registro_C191: Tregistro_C191List;
    registro_C195: Tregistro_C195List;
    constructor Create ;
    destructor Destroy ; override ;
  end;

  Tregistro_C190List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C010 ;
    function Get(Index: Integer): Tregistro_C190 ;
  public
    property Items[Index: Integer]: Tregistro_C190 read Get;
    function AddNew: Tregistro_C180;
    function IndexOf(const cod_item: Integer): Tregistro_C190;
    constructor Create(AOwner: Tregistro_C010) ;
  end;}
  {$ENDREGION}

  {$REGION 'REGISTRO C400 - EQUIPAMENTO ECF (CÓDIGO 02 e 2D)'}
  Tregistro_C400 = class(EFDCommon.Tregistro_C400)
  private
    fOwner: Tregistro_C400List	;
  public
    registro_C405: Tregistro_C405List;
    constructor Create;
    destructor Destroy; override ;
  end;

  Tregistro_C400List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C010 ;
    function Get(Index: Integer): Tregistro_C400 ;
  public
    property Items[Index: Integer]: Tregistro_C400 read Get;
    function AddNew: Tregistro_C400;
    function IndexOf(const cod_mod, ecf_mod, ecf_fab: string): Tregistro_C400; overload ;
    constructor Create(AOwner: Tregistro_C010);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C405: REDUÇÃO Z (CÓDIGO 02, 2D e 60)'}
  Tregistro_C405 = class(EFDCommon.Tregistro_C405)
  private
    fOwner: Tregistro_C405List	;
  public
    registro_C481: Tregistro_C481List ;
    registro_C485: Tregistro_C485List ;
    constructor Create;
    destructor Destroy; override ;
  end;

  Tregistro_C405List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C400	;
    function Get(Index: Integer): Tregistro_C405 ;
  public
    property Items[Index: Integer]: Tregistro_C405 read Get;
    function AddNew: Tregistro_C405;
    function IndexOf(const crz: Integer): Tregistro_C405; overload ;
    constructor Create(AOwner: Tregistro_C400) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C481: RESUMO DIÁRIO DE DOCUMENTOS EMITIDOS POR ECF – PIS/PASEP (CÓDIGOS 02 e 2D)'}
  Tregistro_C481 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C481List	;
  protected
    function GetRow: string; override;
  public
    cst_pis: Byte ;
    vl_item: Currency ;
    vl_bc_pis: Currency;
    aliq_pis: Currency;
    quant_bc_pis: Currency;
    aliq_pis_quant: Currency;
    cod_item: string ;
    cod_cta: string ;
    function vl_pis: Currency;
  end;

  Tregistro_C481List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C405	;
    function Get(Index: Integer): Tregistro_C481 ;
  public
    property Items[Index: Integer]: Tregistro_C481 read Get;
    function AddNew: Tregistro_C481;
    function IndexOf(const cst_pis: Word; const cod_item: string): Tregistro_C481; overload ;
    constructor Create(AOwner: Tregistro_C405) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C485: RESUMO DIÁRIO DE DOCUMENTOS EMITIDOS POR ECF – COFINS (CÓDIGOS 02 e 2D)'}
  Tregistro_C485 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C485List	;
  protected
    function GetRow: string; override;
  public
    cst_cofins: Byte ;
    vl_item: Currency ;
    vl_bc_cofins: Currency;
    aliq_cofins: Currency;
    quant_bc_cofins: Currency;
    aliq_cofins_quant: Currency;
    cod_item: string ;
    cod_cta: string ;
    function vl_cofins: Currency;
  end;

  Tregistro_C485List = class(TBaseEFDList)
  private
    fOwner: Tregistro_C405	;
    function Get(Index: Integer): Tregistro_C485 ;
  public
    property Items[Index: Integer]: Tregistro_C485 read Get;
    function AddNew: Tregistro_C485;
    function IndexOf(const cst_cofins: Word; const cod_item: string): Tregistro_C485; overload ;
    constructor Create(AOwner: Tregistro_C405) ;
  end;
  {$ENDREGION}


  {$REGION 'REGISTRO C990: ENCERRAMENTO DO BLOCO C'}
  Tregistro_C990 = class
  private
    const reg = 'C990' ;
  private
    fOwner: TBloco_C;
    function Row: string;
  public
    qtd_lin_BC:Integer	;
    constructor Create(AOwner: TBloco_C) ;
  end;
  {$ENDREGION}

  TBloco_C = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_C001: Tregistro_C001;
    registro_C990: Tregistro_C990;
  public
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  public
    function NewReg_C010(const cnpj, indesc: string): Tregistro_C010 ;
    function NewReg_C100(reg_C010: Tregistro_C010 ;
                         const ind_oper:TIndTypOper;
                         const ind_emit:TIndEmiDoc ;
                         const cod_part:string ;
                         const cod_mod,ser_doc:string;
                         const cod_sit:TCodSitDoc ;
                         const num_doc: Integer): Tregistro_C100 ;
    function NewReg_C400(reg_C010: Tregistro_C010 ;
                         const cod_mod, ecf_mod, ecf_fab: string): Tregistro_C400 ;
  end;

{$ENDREGION}

implementation

uses DateUtils, StrUtils,
  EFDUtils ;

{ TBloco_C }

constructor TBloco_C.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_C001:=Tregistro_C001.Create(Self) ;
    registro_C990:=Tregistro_C990.Create(Self) ;
end;

destructor TBloco_C.Destroy;
begin
    registro_C001.Destroy ;
    registro_C990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_C.DoExec(AFile: TFileEFD);
var
    I,J,K,L: Integer;
var
    r_C010:Tregistro_C010;

var
    r_C100:Tregistro_C100;
    r_C170:Tregistro_C170;

var
    r_C400: Tregistro_C400;
    r_C405: Tregistro_C405;
    r_C481: Tregistro_C481;
    r_C485: Tregistro_C485;

begin
    AFile.NewLine(registro_C001.Row);

    for I :=0 to registro_C001.registro_C010.Count -1 do
    begin
        r_C010 :=registro_C001.registro_C010.Items[I] ;
        AFile.NewLine(r_C010.Row);

        for J :=0 to r_C010.registro_C100.Count -1 do
        begin
            r_C100 :=r_C010.registro_C100.Items[J] ;
            AFile.NewLine(r_C100.Row);

            for K :=0 to r_C100.registro_C170.Count -1 do
            begin
                r_C170 :=r_C100.registro_C170.Items[K] ;
                AFile.NewLine(r_C170.Row);
            end;
        end;

        for J :=0 to r_C010.registro_C400.Count -1 do
        begin
            r_C400 :=r_C010.registro_C400.Items[J] ;
            AFile.NewLine(r_C400.Row);

            for K :=0 to r_C400.registro_C405.Count -1 do
            begin
                r_C405 :=r_C400.registro_C405.Items[K] ;
                AFile.NewLine(r_C405.Row);

                for L := 0 to r_C405.registro_C481.Count - 1 do
                begin
                    r_C481 :=r_C405.registro_C481.Items[L] ;
                    AFile.NewLine(r_C481.Row);
                end;

                for L := 0 to r_C405.registro_C485.Count - 1 do
                begin
                    r_C485 :=r_C405.registro_C485.Items[L] ;
                    AFile.NewLine(r_C485.Row);
                end;

            end;
        end;



    end;

    AFile.NewLine(registro_C990.Row)	;
end;

procedure TBloco_C.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_C990.qtd_lin_BC, qtd_lin) ;
end;

function TBloco_C.NewReg_C010(const cnpj, indesc: string): Tregistro_C010;
begin
    Result :=registro_C001.registro_C010.IndexOf(cnpj) ;
    if Result = nil then
    begin
        Result :=registro_C001.registro_C010.AddNew ;
        Result.cnpj :=cnpj ;
        Result.ind_escri :=indesc ;
    end;
end;

function TBloco_C.NewReg_C100(reg_C010: Tregistro_C010 ;
                              const ind_oper:TIndTypOper;
                              const ind_emit:TIndEmiDoc ;
                              const cod_part:string ;
                              const cod_mod,ser_doc:string;
                              const cod_sit:TCodSitDoc ;
                              const num_doc: Integer): Tregistro_C100;
begin
    Result :=reg_C010.registro_C100.IndexOf(ind_oper,
                                            ind_emit,
                                            cod_part,
                                            cod_mod,
                                            ser_doc,
                                            cod_sit,
                                            num_doc);
    if Result = nil then
    begin
        Result :=reg_C010.registro_C100.AddNew;
        Result.ind_oper:=ind_oper;
        Result.ind_emit:=ind_emit;
        Result.cod_part:=cod_part;
        Result.cod_mod :=cod_mod;
        Result.cod_sit :=cod_sit;
        Result.ser_doc :=ser_doc;
        Result.num_doc :=num_doc;
    end;
end;

function TBloco_C.NewReg_C400(reg_C010: Tregistro_C010; const cod_mod, ecf_mod,
  ecf_fab: string): Tregistro_C400;
begin
    Result :=reg_C010.registro_C400.IndexOf(cod_mod, ecf_mod, ecf_fab);
    if Result = nil then
    begin
        Result :=reg_C010.registro_C400.AddNew;
        Result.cod_mod:=cod_mod;
        Result.ecf_mod:=ecf_mod;
        Result.ecf_fab:=ecf_fab;
    end;
end;

{ Tregistro_C001 }

constructor Tregistro_C001.Create(AOwner: TBloco_C);
begin
    inherited Create('C001');
    fOwner :=AOwner ;
    registro_C010 :=Tregistro_C010List.Create(Self) ;
end;

destructor Tregistro_C001.Destroy;
begin

    inherited;
end;

function Tregistro_C001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD ;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_C990 }

constructor Tregistro_C990.Create(AOwner: TBloco_C);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_C990.Row: string;
begin
    Inc(Self.qtd_lin_BC)	;
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BC) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_C100List }

function Tregistro_C100List.AddNew: Tregistro_C100;
begin
    Result :=Tregistro_C100.Create;
    Result.fOwner :=Self ;
    //Result.fIndex :=Self.Count ;
    Result.Status :=rsNew ;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_C100List.Create(AOwner: Tregistro_C010);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

function Tregistro_C100List.Get(Index: Integer): Tregistro_C100;
begin
    Result :=Tregistro_C100(inherited Items[Index]) ;
end;

function Tregistro_C100List.IndexOf(const ind_oper:TIndTypOper;
                                    const ind_emit:TIndEmiDoc ;
                                    const cod_part:string ;
                                    const cod_mod,ser_doc:string;
                                    const cod_sit:TCodSitDoc ;
                                    const num_doc: Integer): Tregistro_C100;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I] ;
        if(Result.ind_oper =ind_oper)and
          (Result.ind_emit =ind_emit)and
          (Result.cod_part =cod_part)and
          (Result.cod_mod  =cod_mod )and
          (Result.cod_sit  =cod_sit )and
          (Result.ser_doc  =ser_doc )and
          (Result.num_doc  =num_doc )then
        begin
            Result.Status :=rsRead ;
            Break ;
        end
        else
        begin
            Result :=nil  ;
        end;
    end;
end;

{ Tregistro_C100 }

constructor Tregistro_C100.Create;
begin
    inherited Create('C100');
    registro_C170 :=Tregistro_C170List.Create(Self);
end;

destructor Tregistro_C100.Destroy;
begin
    registro_C170.Destroy ;
    inherited;
end;

function Tregistro_C100.getDesc: Currency;
var
    I:Integer ;
begin
    //if (Self.ind_oper=toEnt)and(Self.typ_part=parEmit) then
    if Self.ind_emit=emiTerc then
    begin
        Result :=0 ;
        for I :=0 to Self.registro_C170.Count -1 do
        begin
            Result :=Result +Self.registro_C170.Items[I].vl_desc ;
        end;
    end
    else begin
        Result :=fvl_desc ;
    end;
end;

function Tregistro_C100.getFret: Currency;
var
    I:Integer ;
begin
    //if (Self.ind_oper=toEnt)and(Self.typ_part=parEmit) then
    if Self.ind_emit=emiTerc then
    begin
        Result :=0;
        for I :=0 to Self.registro_C170.Count -1 do
        begin
            Result :=Result +Self.registro_C170.Items[I].vl_fret ;
        end;
    end
    else begin
        Result :=fvl_fret ;
    end;
end;

function Tregistro_C100.getOutDa: Currency;
var
    I:Integer ;
begin
    //if (Self.ind_oper=toEnt)and(Self.typ_part=parEmit) then
    if Self.ind_emit=emiTerc then
    begin
        Result :=0 ;
        for I :=0 to Self.registro_C170.Count -1 do
        begin
            Result :=Result +Self.registro_C170.Items[I].vl_out_da ;
        end;
    end
    else begin
        Result :=fvl_out_da ;
    end;
end;

{function Tregistro_C100.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_oper),1,'0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_emit),1,'0');
    if Self.cod_sit<>csDocRegular then
    begin
    		Result	:=Result +Tefd_util.SEP_FIELD ;
    end
    else begin
    		Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_part,10);
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
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_merc);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_fret),1,'1');
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_fret);
        Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_seg);
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
end;}

function Tregistro_C100.getVlDoc: Currency;
var
    I:Integer;
    r_C170:Tregistro_C170;
begin
    Result:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        r_C170 :=Self.registro_C170.Items[i];
        if Self.ind_oper=toEnt then
            Result :=Result +(r_C170.vl_item -r_C170.vl_desc)
                            +r_C170.vl_fret
                            +r_C170.vl_out_da
                            +r_C170.vl_icmsst
                            +r_C170.vl_ipi
        else
            Result :=Result +r_C170.vl_item
                            +r_C170.vl_icmsst
                            +r_C170.vl_ipi;
    end;
{    case Self.ind_oper of
        toEnt:
        begin
            for i :=0 to Self.registro_C170.Count -1 do
            begin
                r_C170 :=Self.registro_C170.Items[i];
                Result :=Result +(r_C170.vl_item -r_C170.vl_desc)
                                +r_C170.vl_fret
                                +r_C170.vl_out_da
                                +r_C170.vl_icmsst
                                +r_C170.vl_ipi;
            end;
        end;
        toSai:
        begin
            for i :=0 to Self.registro_C170.Count -1 do
            begin
                r_C170 :=Self.registro_C170.Items[i];
                Result :=Result +r_C170.vl_item
                                +r_C170.vl_icmsst
                                +r_C170.vl_ipi
            end;
        end;
    end;}
    if Self.ind_emit=emiProp then
    begin
        Result :=Result +Self.vl_fret
                        +Self.vl_out_da
                        -Self.vl_desc;
    end;
end;

function Tregistro_C100.vl_abat_nt: Currency;
begin
  Result :=0;
end;

function Tregistro_C100.vl_bc_icms: Currency;
var i:Integer	;
begin
    Result	:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        Result :=Result +Self.registro_C170.Items[i].vl_bc_icms	;
    end;
end;

function Tregistro_C100.vl_bc_icmsst: Currency;
var i:Integer	;
begin
    Result	:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        Result :=Result +Self.registro_C170.Items[i].vl_bc_icmsst	;
    end;
end;

function Tregistro_C100.vl_icms: Currency;
var i:Integer	;
begin
    Result	:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        Result :=Result +Self.registro_C170.Items[i].vl_icms	;
    end;
end;

function Tregistro_C100.vl_icmsst: Currency;
var i:Integer	;
begin
    Result	:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        Result :=Result +Self.registro_C170.Items[i].vl_icmsst	;
    end;
end;

function Tregistro_C100.vl_ipi: Currency;
var i:Integer	;
begin
    Result:=0;
    for i :=0 to Self.registro_C170.Count -1 do
    begin
        Result :=Result +Self.registro_C170.Items[i].vl_ipi	;
    end;
end;

function Tregistro_C100.vl_merc: Currency;
var i:Integer	;
begin
    Result	:=0;
    if (cod_mod<>'55')or(ind_emit<>emiProp)or(cod_sit in[csDocRegular,csEscExtDocRegular]) then
    begin
        for i :=0 to Self.registro_C170.Count -1 do
        begin
            Result :=Result +Self.registro_C170.Items[i].vl_item	;
        end;
    end;
end;

function Tregistro_C100.vl_cofins: Currency;
var
    I:Integer	;
begin
    Result	:=0;
    for I :=0 to registro_C170.Count -1 do
    begin
        Result :=Result +registro_C170.Items[i].vl_cofins	;
    end;
end;

function Tregistro_C100.vl_pis: Currency;
var
    I:Integer	;
begin
    Result	:=0;
    for I :=0 to registro_C170.Count -1 do
    begin
        Result :=Result +registro_C170.Items[i].vl_pis	;
    end;
end;

{ Tregistro_C170List }

{function Tregistro_C170List.AddNew: Tregistro_C170;
begin
    Result :=Tregistro_C170.Create('C170') ;
    Result.fOwner :=Self  ;
    Result.fIndex :=Self.Count;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;}

constructor Tregistro_C170List.Create(AOwner: Tregistro_C100);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

{function Tregistro_C170List.Get(Index: Integer): Tregistro_C170;
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
            Result :=Self.Items[I]  ;
        end;
    end;
end;}

procedure Tregistro_C170List.Notify(Ptr: Pointer; Action: TListNotification);
begin
    //registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Tregistro_C170(Ptr).Reg);
    inherited Notify(Ptr, Action);
end;

{ Tregistro_C170

function Tregistro_C170.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.nro_item,03);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_item);
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
end;}

{ Tregistro_C010 }

function Tregistro_C010List.AddNew: Tregistro_C010;
begin
    Result :=Tregistro_C010.Create;
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result) ;

    // registra nos tatalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);
end;

{ Tregistro_C010List }

constructor Tregistro_C010List.Create(AOwner: Tregistro_C001);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

function Tregistro_C010List.Get(Index: Integer): Tregistro_C010;
begin
    Result :=Tregistro_C010(inherited Items[Index]) ;
end;

function Tregistro_C010List.IndexOf(const cnpj: string): Tregistro_C010;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cnpj =cnpj then
        begin
            Result :=Self.Items[I];
            Result.Status :=rsRead;
            Break ;
        end;
    end;
end;

{ Tregistro_C010 }

constructor Tregistro_C010.Create;
begin
    inherited Create('C010');
    registro_C100 :=Tregistro_C100List.Create(Self);
    registro_C400 :=Tregistro_C400List.Create(Self);
end;

destructor Tregistro_C010.Destroy;
begin
    registro_C100.Destroy ;
    registro_C400.Destroy ;
    inherited Destroy ;
end;

function Tregistro_C010.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14,True) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.ind_escri ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C180List }

function Tregistro_C180List.AddNew: Tregistro_C180;
begin
    Result :=Tregistro_C180.Create ;
    Result.fOwner :=Self ;
    inherited Add(Result);
    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);
end;

constructor Tregistro_C180List.Create(AOwner: Tregistro_C010);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_C180List.Get(Index: Integer): Tregistro_C180;
begin
    Result :=Tregistro_C180(inherited Items[Index]) ;
end;

function Tregistro_C180List.IndexOf(const cod_item: Integer): Tregistro_C180;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cod_item =cod_item then
        begin
            Result :=Self.Items[I];
            Break ;
        end;
    end;
end;


{ Tregistro_C180 }

constructor Tregistro_C180.Create;
begin
    inherited Create;
    registro_C181:=Tregistro_C181List.Create(Self);
    registro_C185:=Tregistro_C185List.Create(Self);
end;

destructor Tregistro_C180.Destroy;
begin
    registro_C181.Destroy;
    registro_C185.Destroy;
    inherited Destroy;
end;

function Tregistro_C180.Row: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_mod;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_doc_ini);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_doc_fin);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_item) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_ncm,8) ;
    Result :=Result +Tefd_util.SEP_FIELD +Self.ex_ipi ;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C181List }

function Tregistro_C181List.AddNew: Tregistro_C181;
begin
    Result :=Tregistro_C181.Create;
    Result.fOwner :=Self ;
    inherited Add(Result);
    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);
end;

constructor Tregistro_C181List.Create(AOwner: Tregistro_C180);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_C181List.Get(Index: Integer): Tregistro_C181;
begin
    Result :=Tregistro_C181(inherited Items[Index]) ;
end;

function Tregistro_C181List.IndexOf(const cst_pis, cfop: Word;
  const aliq_pis: Currency): Tregistro_C181;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I] ;
        if(Result.cst_pis  =cst_pis )and
          (Result.cfop     =cfop    )and
          (Result.aliq_pis =aliq_pis)then
        begin
            Break ;
        end
        else begin
            Result :=nil;
        end;
    end;
end;


{ Tregistro_C181 }

function Tregistro_C181.Row: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_pis);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_desc);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_pis);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis,'0.0000','0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_bc_pis,'0.000','0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis_qtd,'0.0000');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis);
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C185List }

function Tregistro_C185List.AddNew: Tregistro_C185;
begin
    Result :=Tregistro_C185.Create;
    Result.fOwner :=Self ;
    inherited Add(Result);
    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);
end;

constructor Tregistro_C185List.Create(AOwner: Tregistro_C180);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_C185List.Get(Index: Integer): Tregistro_C185;
begin
    Result :=Tregistro_C185(inherited Items[Index]);
end;

function Tregistro_C185List.IndexOf(const cst_cofins, cfop: Word;
  const aliq_cofins: Currency): Tregistro_C185;
var
    I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I] ;
        if(Result.cst_cofins  =cst_cofins )and
          (Result.cfop        =cfop       )and
          (Result.aliq_cofins =aliq_cofins)then
        begin
            Break ;
        end
        else begin
            Result :=nil;
        end;
    end;
end;

{ Tregistro_C185 }

function Tregistro_C185.Row: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_cofins);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_desc);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_cofins);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins,'0.0000','0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_bc_cofins,'0.000','0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins_qtd,'0.0000');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
    Result :=Result +Tefd_util.SEP_FIELD +Self.cod_cta;
    Result :=Result +Tefd_util.SEP_FIELD ;
end;


{ Tregistro_C400List }

function Tregistro_C400List.AddNew: Tregistro_C400;
begin
  Result :=Tregistro_C400.Create;
  Result.fOwner :=Self ;
  Result.Status :=rsNew;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

  //bloco C tem dados
  Self.fOwner.fOwner.fOwner.ind_mov :=movDat;

end;

constructor Tregistro_C400List.Create(AOwner: Tregistro_C010);
begin
  inherited Create;
  fOwner :=AOwner ;
end;

function Tregistro_C400List.Get(Index: Integer): Tregistro_C400;
begin
  Result :=Tregistro_C400(inherited Items[Index]) ;
end;

function Tregistro_C400List.IndexOf(const cod_mod, ecf_mod,
  ecf_fab: string): Tregistro_C400;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if(Self.Items[I].cod_mod=cod_mod)and
        (Self.Items[I].ecf_mod=ecf_mod)and
        (Self.Items[I].ecf_fab=ecf_fab)then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C400 }

constructor Tregistro_C400.Create;
begin
  inherited Create('C400');
  registro_C405 :=Tregistro_C405List.Create(Self);
end;

destructor Tregistro_C400.Destroy;
begin
  registro_C405.Destroy ;
  inherited;
end;

{ Tregistro_C405List }

function Tregistro_C405List.AddNew: Tregistro_C405;
begin
  Result :=Tregistro_C405.Create;
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

end;

constructor Tregistro_C405List.Create(AOwner: Tregistro_C400);
begin
  inherited Create;
  fOwner :=AOwner ;
end;

function Tregistro_C405List.Get(Index: Integer): Tregistro_C405;
begin
  Result :=Tregistro_C405(inherited Items[Index]) ;
end;

function Tregistro_C405List.IndexOf(const crz: Integer): Tregistro_C405;
var
  I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if Self.Items[I].crz  =crz then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C405 }

constructor Tregistro_C405.Create;
begin
  inherited Create('C405');
  Self.Status   :=rsNew;
  registro_C481 :=Tregistro_C481List.Create(Self) ;
  registro_C485 :=Tregistro_C485List.Create(Self) ;
end;

destructor Tregistro_C405.Destroy;
begin
  registro_C481.Destroy ;
  registro_C485.Destroy ;
  inherited;
end;

{ Tregistro_C481List }

function Tregistro_C481List.AddNew: Tregistro_C481;
begin
  Result :=Tregistro_C481.Create('C481');
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

end;

constructor Tregistro_C481List.Create(AOwner: Tregistro_C405);
begin
  inherited Create;
  fOwner :=AOwner ;
end;

function Tregistro_C481List.Get(Index: Integer): Tregistro_C481;
begin
  Result :=Tregistro_C481(inherited Items[Index]) ;
end;

function Tregistro_C481List.IndexOf(const cst_pis: Word;
  const cod_item: string): Tregistro_C481;
var
  I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if(Self.Items[I].cst_pis  =cst_pis)and
        (Self.Items[I].cod_item  =cod_item)then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C481 }

function Tregistro_C481.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_pis,2,'99');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_pis);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.quant_bc_pis,'0.000') ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis_quant,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_cta) ;
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_C481.vl_pis: Currency;
begin
  Result :=(Self.vl_bc_pis *Self.aliq_pis)/100 ;
end;

{ Tregistro_C485List }

function Tregistro_C485List.AddNew: Tregistro_C485;
begin
  Result :=Tregistro_C485.Create('C485');
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

end;

constructor Tregistro_C485List.Create(AOwner: Tregistro_C405);
begin
  inherited Create;
  fOwner :=AOwner ;
end;

function Tregistro_C485List.Get(Index: Integer): Tregistro_C485;
begin
  Result :=Tregistro_C485(inherited Items[Index]) ;
end;

function Tregistro_C485List.IndexOf(const cst_cofins: Word;
  const cod_item: string): Tregistro_C485;
var
  I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if(Self.Items[I].cst_cofins =cst_cofins)and
        (Self.Items[I].cod_item   =cod_item)then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;

end;

{ Tregistro_C485 }

function Tregistro_C485.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_cofins,2,'99');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_cofins);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.quant_bc_cofins,'0.000') ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins_quant,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_cta) ;
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_C485.vl_cofins: Currency;
begin
  Result :=(Self.vl_bc_cofins *Self.aliq_cofins)/100 ;
end;

end.
