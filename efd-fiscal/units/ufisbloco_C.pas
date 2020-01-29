{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              SPED Fiscal                                                    }
{              Copyright (c) 1992,2012 Suporteware                            }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI)
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}

unit ufisbloco_C;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;


{$REGION 'BLOCO C: DOCUMENTOS FISCAIS I - MERCADORIAS (ICMS/IPI)'}
type
  TBloco_C = class ;
//  Tregistro_C001 = class;
//  Tregistro_C100 = class;
  Tregistro_C100List = class;
//  Tregistro_C170 = class ;
  Tregistro_C170List = class;
  Tregistro_C190 = class;
  Tregistro_C190List = class;
  Tregistro_C400List = class;
  Tregistro_C405List = class ;
  Tregistro_C420 = class;
  Tregistro_C420List = class;
  Tregistro_C460 = class;
  Tregistro_C460List = class;
  Tregistro_C470 = class;
  Tregistro_C470List = class;
  Tregistro_C490 = class;
  Tregistro_C490List = class;

  {$REGION 'REGISTRO C001: ABERTURA DO BLOCO C'}
  Tregistro_C001 = class(TOpenBloco)
  protected
    function GetRow: string; override ;
  private
    fOwner: TBloco_C;
  public
    registro_C100: Tregistro_C100List;
    registro_C400: Tregistro_C400List;
    constructor Create(AOwner: TBloco_C);
    destructor Destroy; override;
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
  public
    function vl_merc: Currency; override ;
    function vl_abat_nt: Currency; override ;
    function vl_bc_icms: Currency; override ;
    function vl_icms: Currency; override ;
    function vl_bc_icmsst: Currency; override;
    function vl_icmsst: Currency; override ;
    function vl_ipi: Currency; override ;
    function vl_pis:Currency; override ;
    function vl_cofins: Currency; override ;
  public
    registro_C170: Tregistro_C170List;
    registro_C190: Tregistro_C190List;
    constructor Create;
    destructor Destroy; override ;
  end;

  Tregistro_C100List = class(TBaseEFDList)
  protected
    fOwner: Tregistro_C001 ;
    function Get(Index: Integer): Tregistro_C100 ;
  public
    property Items[Index: Integer]: Tregistro_C100 read Get;
    constructor Create(AOwner: Tregistro_C001);
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
  Tregistro_C170List = class (EFDCommon.Tregistro_C170List)
  private
    fOwner: Tregistro_C100 ;
    protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create(AOwner: Tregistro_C100) ;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04 E 55)'}
  Tregistro_C190 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C190List	;
  protected
    function GetRow: string; override ;
  public
    cst_icms      :Word	;
    cfop          :Word ;
    per_icms      :Currency;

    { Somatorias na combinação de CST_ICMS, CFOP e alíquota do ICMS }

    vl_oper 			:Currency;//Valor das mercadorias somadas aos valores de fretes,
                            //seguros e outras despesas acessórias e os valores de ICMS_ST e IPI (somente
                            //quando o IPI está destacado na NF), subtraído o desconto incondicional.

    vl_bc_icms   :Currency; //A soma dos valores do Campo VL_BC_ICMS d os registros C170 (itens), se existirem

    vl_icms      :Currency;
    vl_bc_icms_st:Currency;
    vl_icms_st   :Currency;
    vl_rbc       :Currency;
    vl_ipi       :Currency;
    cod_obs       :string;
  end;

  Tregistro_C190List = class (TBaseEFDList)
  private
    fOwner: Tregistro_C100 ;
    function Get(Index: Integer): Tregistro_C190	;
  public
    property Items[Index: Integer]: Tregistro_C190 read Get;
    constructor Create(AOwner: Tregistro_C100) ;
    function AddNew: Tregistro_C190;
    function IndexOf(const cst_icms, cfop: Word; const per_icms: Currency): Tregistro_C190;
    function vlr_icms: Currency	;
    function vlr_icms_st: Currency;
    function vlr_rbc: Currency;
  end;
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
    fOwner: Tregistro_C001 ;
    function Get(Index: Integer): Tregistro_C400 ;
  public
    property Items[Index: Integer]: Tregistro_C400 read Get;
    function AddNew: Tregistro_C400;
    function IndexOf(const cod_mod, ecf_mod, ecf_fab: string): Tregistro_C400; overload ;
    constructor Create(AOwner: Tregistro_C001);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C405: REDUÇÃO Z (CÓDIGO 02, 2D e 60)'}
  Tregistro_C405 = class(EFDCommon.Tregistro_C405)
  private
    fOwner: Tregistro_C405List	;
  public
    registro_C420: Tregistro_C420List ;
    registro_C460: Tregistro_C460List ;
    registro_C490: Tregistro_C490List ;
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

  {$REGION 'REGISTRO C420: REGISTRO DOS TOTALIZADORES PARCIAIS DA REDUÇÃO Z (COD 02, 2D e 60)'}
  Tregistro_C420 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C420List	;
  protected
    function GetRow: string; override ;
  public
    cod_tot_par: string ;
    vlr_acum_tot: Currency;
    nr_tot: Byte;
    descr_nr_tot: string ;
  end;

  Tregistro_C420List = class (TBaseEFDList)
  private
    fOwner: Tregistro_C405	;
    function Get(Index: Integer): Tregistro_C420 ;
  public
    property Items[Index: Integer]: Tregistro_C420 read Get;
    function AddNew: Tregistro_C420;
    function IndexOf(const cod_tot_par: string; const nr_tot: Byte): Tregistro_C420; overload ;
    constructor Create(AOwner: Tregistro_C405);
  end;

  {$ENDREGION}

  {$REGION 'REGISTRO C460: DOCUMENTO FISCAL EMITIDO POR ECF (CÓDIGO 02, 2D e 60).'}
  Tregistro_C460 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C460List	;
  protected
    function GetRow: string; override ;
  public
    cod_mod: string ;
    cod_sit: TCodSitDoc ;
    num_doc: Integer;
    dt_doc: TDateTime ;
    vl_pis: Currency ;
    vl_cofins: Currency ;
    cpf_cnpj: string ;
    nom_adq: string ;
    registro_C470: Tregistro_C470List ;
    function vl_doc: Currency ;
  public
    constructor Create;
    destructor Destroy; override ;
  end;

  Tregistro_C460List = class (TBaseEFDList)
  private
    fOwner: Tregistro_C405	;
    function Get(Index: Integer): Tregistro_C460 ;
  public
    property Items[Index: Integer]: Tregistro_C460 read Get;
    function AddNew: Tregistro_C460;
    function IndexOf(const cod_mod: string; const num_doc: Integer;
      const dt_doc: TDateTime): Tregistro_C460; overload ;
    constructor Create(AOwner: Tregistro_C405);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C470: ITENS DO DOCUMENTO FISCAL EMITIDO POR ECF (CÓDIGO 02 e 2D).'}
  Tregistro_C470 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C470List	;
  protected
    function GetRow: string; override ;
  public
    cod_item: string; //Integer ;
    qtd_item: Currency;
    qtd_canc: Currency;
    unid_item: string ;
    vl_item: Currency ;
    cst_icms: Byte ;
    cfop: Word ;
    aliq_icms: Currency ;
    vl_pis: Currency;
    vl_cofins: Currency;
  end;

  Tregistro_C470List = class (TBaseEFDList)
  private
    fOwner: Tregistro_C460	;
    function Get(Index: Integer): Tregistro_C470 ;
  public
    property Items[Index: Integer]: Tregistro_C470 read Get;
    function AddNew: Tregistro_C470;
    function IndexOf(const cod_item: string): Tregistro_C470; overload ;
    constructor Create(AOwner: Tregistro_C460);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO C490: REGISTRO ANALÍTICO DO MOVIMENTO DIÁRIO (CÓDIGO 02, 2D e 60).'}
  Tregistro_C490 = class(TBaseRegistro)
  private
    fOwner: Tregistro_C490List	;
  protected
    function GetRow: string; override ;
  public
    cst_icms      :Word	;
    cfop          :Word ;
    per_icms      :Currency;
    vl_opr 			:Currency;
    vl_bc_icms   :Currency;
    vl_icms      :Currency;
    cod_obs       :string;
  end;

  Tregistro_C490List = class (TBaseEFDList)
  private
    fOwner: Tregistro_C405	;
    function Get(Index: Integer): Tregistro_C490	;
  public
    property Items[Index: Integer]: Tregistro_C490 read Get;
    constructor Create(AOwner: Tregistro_C405) ;
    function AddNew: Tregistro_C490;
    function IndexOf(const cst_icms, cfop: Word; const per_icms: Currency): Tregistro_C490;
    function vlr_icms: Currency	;
  end;
  {$ENDREGION}


  {$REGION 'REGISTRO C990: ENCERRAMENTO DO BLOCO C'}
  Tregistro_C990 = class(TBaseRegistro)
  private
    fOwner: TBloco_C;
  protected
    function GetRow: string; override ;
  public
    //const reg = 'C990' ;
    qtd_lin_BC:Integer	;
    constructor Create(AOwner: TBloco_C) ;
  end;
  {$ENDREGION}

  TBloco_C = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1);
  public
    registro_C001: Tregistro_C001;
    registro_C990: Tregistro_C990;
  public
    function NewReg_C100(const ind_oper:TIndTypOper;
                         const ind_emit:TIndEmiDoc ;
                         const cod_part:string ;
                         const cod_mod,ser_doc:string;
                         const cod_sit:TCodSitDoc ;
                         const num_doc: Integer): Tregistro_C100 ;
    function NewReg_C400(const cod_mod, ecf_mod, ecf_fab: string): Tregistro_C400 ;
  public
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}

implementation

uses DateUtils, StrUtils,
  EFDUtils;

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
    I,J,K,L: Integer ;
var
    r_C100: Tregistro_C100;
    r_C170: Tregistro_C170;
    r_C190: Tregistro_C190;
var
    r_C400: Tregistro_C400;
    r_C405: Tregistro_C405;
    r_C420: Tregistro_C420;
    r_C460: Tregistro_C460;
    r_C470: Tregistro_C470;
    r_C490: Tregistro_C490;

begin
    AFile.NewLine(registro_C001.Row);

    for I :=0 to registro_C001.registro_C100.Count -1 do
    begin
        r_C100 :=registro_C001.registro_C100.Items[I] ;

        if r_C100.Status = rsDeleted then
        begin
          Continue ;
        end;

        AFile.NewLine(r_C100.Row);

        for J :=0 to r_C100.registro_C170.Count -1 do
        begin
            r_C170 :=r_C100.registro_C170.Items[J] ;
            AFile.NewLine(r_C170.Row);
        end;

        for J :=0 to r_C100.registro_C190.Count -1 do
        begin
            r_C190 :=r_C100.registro_C190.Items[J] ;
            AFile.NewLine(r_C190.Row);
        end;
    end;

    for I :=0 to registro_C001.registro_C400.Count -1 do
    begin
        r_C400 :=registro_C001.registro_C400.Items[I] ;
        if r_C400.Status = rsDeleted then
        begin
          Continue ;
        end;

        AFile.NewLine(r_C400.Row);

        for J :=0 to r_C400.registro_C405.Count -1 do
        begin
            r_C405 :=r_C400.registro_C405.Items[J] ;
            AFile.NewLine(r_C405.Row);

            for K :=0 to r_C405.registro_C420.Count -1 do
            begin
                r_C420 :=r_C405.registro_C420.Items[K] ;
                AFile.NewLine(r_C420.Row);
            end;

            for K :=0 to r_C405.registro_C460.Count -1 do
            begin
                r_C460 :=r_C405.registro_C460.Items[K] ;
                AFile.NewLine(r_C460.Row);
                for L :=0 to r_C460.registro_C470.Count -1 do
                begin
                    r_C470 :=r_C460.registro_C470.Items[L] ;
                    AFile.NewLine(r_C470.Row);
                end;
            end;

            for K :=0 to r_C405.registro_C490.Count -1 do
            begin
                r_C490 :=r_C405.registro_C490.Items[K] ;
                AFile.NewLine(r_C490.Row);
            end;

        end;

    end;

    AFile.NewLine(registro_C990.Row);
end;

procedure TBloco_C.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_C990.qtd_lin_BC, qtd_lin) ;
end;

function TBloco_C.NewReg_C100(const ind_oper:TIndTypOper;
                              const ind_emit:TIndEmiDoc ;
                              const cod_part:string ;
                              const cod_mod,ser_doc:string;
                              const cod_sit:TCodSitDoc ;
                              const num_doc: Integer): Tregistro_C100;
begin
    Result :=registro_C001.registro_C100.IndexOf(ind_oper,
                                                 ind_emit,
                                                 cod_part,
                                                 cod_mod,
                                                 ser_doc,
                                                 cod_sit,
                                                 num_doc);
    if Result = nil then
    begin
        Result :=registro_C001.registro_C100.AddNew;
        Result.ind_oper:=ind_oper;
        Result.ind_emit:=ind_emit;
        Result.cod_part:=cod_part;
        Result.cod_mod :=cod_mod;
        Result.cod_sit :=cod_sit;
        Result.ser_doc :=ser_doc;
        Result.num_doc :=num_doc;
    end;
end;

function TBloco_C.NewReg_C400(const cod_mod, ecf_mod, ecf_fab: string): Tregistro_C400;
begin
    Result :=registro_C001.registro_C400.IndexOf(cod_mod, ecf_mod, ecf_fab) ;
    if Result = nil then
    begin
        Result :=registro_C001.registro_C400.AddNew;
        Result.cod_mod  :=cod_mod;
        Result.ecf_mod  :=ecf_mod;
        Result.ecf_fab  :=ecf_fab;
        Result.Status :=rsNew ;
    end
    else begin
        Result.Status :=rsRead ;
    end;
end;

{ Tregistro_C001 }

constructor Tregistro_C001.Create(AOwner: TBloco_C);
begin
    inherited Create('C001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat;
    registro_C100 :=Tregistro_C100List.Create(Self) ;
    registro_C400 :=Tregistro_C400List.Create(Self) ;
end;

destructor Tregistro_C001.Destroy;
begin
    registro_C100.Destroy ;
    registro_C400.Destroy ;
    inherited Destroy;
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
    inherited Create('C990');
    fOwner :=AOwner ;
end;

function Tregistro_C990.GetRow: string;
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
    Result.Status :=rsNew;
    inherited Add(Result);

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

    //bloco C tem dados
    Self.fOwner.ind_mov :=movDat;
end;

constructor Tregistro_C100List.Create(AOwner: Tregistro_C001);
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
                                    const cod_part:string;
                                    const cod_mod,ser_doc:string;
                                    const cod_sit:TCodSitDoc;
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
          	Result.Status :=rsRead;
            Break ;
        end
        else
        begin
            Result :=nil ;
        end;
    end;
end;

{ Tregistro_C100 }

constructor Tregistro_C100.Create;
begin
    inherited Create('C100');
    registro_C170 :=Tregistro_C170List.Create(Self);
    registro_C190 :=Tregistro_C190List.Create(Self);
    Status :=rsNew;
end;

destructor Tregistro_C100.Destroy;
begin
    registro_C170.Destroy ;
    registro_C190.Destroy ;
    inherited Destroy ;
end;

function Tregistro_C100.getDesc: Currency;
var
    I:Integer ;
begin
  	//if (Self.typ_part=parEmit)and(Self.ind_oper=toEnt) then
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
    //if (Self.typ_part=parEmit)and(Self.ind_oper=toEnt) then
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
    //if (Self.typ_part=parEmit)and(Self.ind_oper=toEnt) then
    if Self.ind_emit=emiTerc then
    begin
        Result :=0 ;
        for I :=0 to Self.registro_C170.Count -1 do
        begin
            Result := Result +
                      Self.registro_C170.Items[I].vl_out_da;
        end;
    end
    else begin
        Result :=fvl_out_da;
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
}
function Tregistro_C100.getVlDoc: Currency;
var
    I:Integer	;
begin
    Result:=0;

    for I :=0 to Self.registro_C190.Count -1 do
    begin
        Result :=Result +Self.registro_C190.Items[I].vl_oper ;
    end;

//    if Self.ind_emit=emiProp then
//    begin
//        Result :=Result + Self.vl_fret +Self.vl_out_da -Self.vl_desc;
//    end;
end;

function Tregistro_C100.vl_abat_nt: Currency;
//var i:Integer	;
begin
    Result :=0;
//    for i :=0 to Self.registro_C190.Count -1 do
//    begin
//        Result :=Result +Self.registro_C190.Items[i].vl_rbc;
//    end;
end;

function Tregistro_C100.vl_bc_icms: Currency;
var i:Integer	;
begin
    Result :=0;
    for i :=0 to Self.registro_C190.Count -1 do
    begin
        Result :=Result +Self.registro_C190.Items[i].vl_bc_icms;
    end;
end;

function Tregistro_C100.vl_bc_icmsst: Currency;
var i:Integer	;
begin
    Result :=0;
    for i :=0 to Self.registro_C190.Count -1 do
    begin
        Result :=Result +Self.registro_C190.Items[i].vl_bc_icms_st;
    end;
end;

function Tregistro_C100.vl_icms: Currency;
begin
    Result	:=Self.registro_C190.vlr_icms;
end;

function Tregistro_C100.vl_icmsst: Currency;
begin
    Result	:=Self.registro_C190.vlr_icms_st;
end;

function Tregistro_C100.vl_ipi: Currency;
var i:Integer	;
begin
    Result:=0;
    for i :=0 to Self.registro_C190.Count -1 do
    begin
        Result :=Result +Self.registro_C190.Items[i].vl_ipi	;
    end;
end;

function Tregistro_C100.vl_merc: Currency;
var i:Integer	;
begin
    Result :=0;
    if cod_sit in[csDocRegular,csEscExtDocRegular] then
    begin
      if(ind_oper = toEnt)or((cod_mod<>'55')and(ind_emit<>emiProp)) then
      begin
        for i :=0 to Self.registro_C170.Count -1 do
        begin
            Result :=Result +Self.registro_C170.Items[i].vl_item;
        end;
      end;
    end;

//    if (cod_mod<>'55')and(ind_emit<>emiProp)and(cod_sit in[csDocRegular,csEscExtDocRegular]) then
//    begin
//        for i :=0 to Self.registro_C170.Count -1 do
//        begin
//            Result :=Result +Self.registro_C170.Items[i].vl_item
//            ;
//        end;
//    end;
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
    Result :=Tregistro_C170.Create('C170');
    Result.fOwner :=Self ;
    inherited Add(Result);

    //registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg);
end;}

constructor Tregistro_C170List.Create(AOwner: Tregistro_C100);
begin
    inherited Create;
    fOwner :=AOwner ;

end;

procedure Tregistro_C170List.Notify(Ptr: Pointer; Action: TListNotification);
begin
    //registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Tregistro_C170(Ptr).Reg);
    inherited Notify(Ptr, Action);
end;

{ Tregistro_C190 }

function Tregistro_C190.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_icms,3,'000');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.per_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_oper);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_bc_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_bc_icms_st,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_icms_st,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_rbc,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_ipi,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_obs,6);
    Result	:=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C190List }

function Tregistro_C190List.AddNew: Tregistro_C190;
begin
    Result	:=Tregistro_C190.Create('C190');
    Result.fOwner	:=Self	;
    inherited Add(Result) ;

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_C190List.Create(AOwner: Tregistro_C100);
begin
    inherited Create;
    fOwner :=AOwner ;
end;

function Tregistro_C190List.Get(Index: Integer): Tregistro_C190;
begin
    Result	:=Tregistro_C190(inherited Items[Index]);
end;

function Tregistro_C190List.IndexOf(const cst_icms, cfop: Word;
  const per_icms: Currency): Tregistro_C190;
var i:Integer	;
begin
    Result	:=nil	;
    for i :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[i] ;
        if(Result.cst_icms=cst_icms)and
          (Result.cfop    =cfop    )and
          (Result.per_icms=per_icms)then
        begin
          Break	;
        end
        else
          Result :=nil ;
    end;
end;

function Tregistro_C190List.vlr_icms: Currency;
var r_C190:Tregistro_C190;
var i:Integer	;
begin
    Result	:=0;
  	for i :=0 to Self.Count -1 do
    begin
        r_C190 :=Self.Items[i];
        Result :=Result +r_C190.vl_icms;
    end;
end;


function Tregistro_C190List.vlr_icms_st: Currency;
var
		I:Integer	;
begin
    Result :=0;
  	for I :=0 to Self.Count -1 do
    begin
        Result :=Result +Self.Items[I].vl_icms_st	;
    end;
end;


function Tregistro_C190List.vlr_rbc: Currency;
var
		I:Integer	;
begin
    Result :=0;
  	for I :=0 to Self.Count -1 do
    begin
        Result :=Result +Self.Items[I].vl_rbc	;
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
  inherited ;
end;

{ Tregistro_C400List }

function Tregistro_C400List.AddNew: Tregistro_C400;
begin
  Result :=Tregistro_C400.Create;
  Result.fOwner :=Self ;
  Result.Status :=rsNew;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.DoInc();
  fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

  //bloco C tem dados
  Self.fOwner.ind_mov :=movDat;

end;

constructor Tregistro_C400List.Create(AOwner: Tregistro_C001);
begin
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

{ Tregistro_C405List }

function Tregistro_C405List.AddNew: Tregistro_C405;
begin
  Result :=Tregistro_C405.Create;
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg);

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
  registro_C420 :=Tregistro_C420List.Create(Self) ;
  registro_C460 :=Tregistro_C460List.Create(Self) ;
  registro_C490 :=Tregistro_C490List.Create(Self) ;
end;

destructor Tregistro_C405.Destroy;
begin
  registro_C420.Destroy ;
  registro_C460.Destroy ;
  registro_C490.Destroy ;
  inherited Destroy ;
end;

{ Tregistro_C420List }

function Tregistro_C420List.AddNew: Tregistro_C420;
begin
  Result :=Tregistro_C420.Create('C420');
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_C420List.Create(AOwner: Tregistro_C405);
begin
  inherited Create();
  fOwner :=AOwner ;

end;

function Tregistro_C420List.Get(Index: Integer): Tregistro_C420;
begin
  Result :=Tregistro_C420(inherited Items[Index]) ;
end;

function Tregistro_C420List.IndexOf(const cod_tot_par: string;
  const nr_tot: Byte): Tregistro_C420;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if(Self.Items[I].cod_tot_par  =cod_tot_par)and
        (Self.Items[I].nr_tot       =nr_tot     )then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C420 }

function Tregistro_C420.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.Reg) ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_tot_par) ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_acum_tot);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.nr_tot,2);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descr_nr_tot) ;
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C460List }

function Tregistro_C460List.AddNew: Tregistro_C460;
begin
  Result :=Tregistro_C460.Create;
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_C460List.Create(AOwner: Tregistro_C405);
begin
  fOwner :=AOwner ;

end;

function Tregistro_C460List.Get(Index: Integer): Tregistro_C460;
begin
  Result :=Tregistro_C460(inherited Items[Index]) ;

end;

function Tregistro_C460List.IndexOf(const cod_mod: string;
  const num_doc: Integer; const dt_doc: TDateTime): Tregistro_C460;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if(Self.Items[I].cod_mod  =cod_mod)and
        (Self.Items[I].num_doc  =num_doc)and
        (Self.Items[I].dt_doc   =dt_doc )then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C460 }

constructor Tregistro_C460.Create;
begin
  inherited Create('C460');
  registro_C470 :=Tregistro_C470List.Create(Self) ;
end;

destructor Tregistro_C460.Destroy;
begin
  registro_C470.Destroy ;
  inherited;
end;

function Tregistro_C460.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Self.cod_mod;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.cod_sit),2,'00');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.num_doc,6);
    if Self.cod_sit = csDocRegular then
    begin
      Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_doc) ;
      Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_doc) ;
      Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis) ;
      Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
      Result  :=Result +Tefd_util.SEP_FIELD +Self.cpf_cnpj;
      Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nom_adq,60);
    end
    else begin
      Result  :=Result +Tefd_util.SEP_FIELD;
      Result  :=Result +Tefd_util.SEP_FIELD;
      Result  :=Result +Tefd_util.SEP_FIELD;
      Result  :=Result +Tefd_util.SEP_FIELD;
      Result  :=Result +Tefd_util.SEP_FIELD;
      Result  :=Result +Tefd_util.SEP_FIELD;
    end;
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_C460.vl_doc: Currency;
var
  I: Integer ;
begin
  Result :=0 ;
  for I :=0 to Self.registro_C470.Count -1 do
  begin
    Result :=Result +Self.registro_C470.Items[I].vl_item ;
  end;
end;

{ Tregistro_C470 }

function Tregistro_C470.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.Reg ;
    Result	:=Result +Tefd_util.SEP_FIELD +Self.cod_item; //Tefd_util.FInt(Self.cod_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_item,'0.000','0') ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_canc,'0.000') ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.unid_item,6) ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_item);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_icms,3,'000');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.aliq_icms,'0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C470List }

function Tregistro_C470List.AddNew: Tregistro_C470;
begin
  Result :=Tregistro_C470.Create('C470');
  Result.fOwner :=Self ;
  inherited Add(Result);

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;

end;

constructor Tregistro_C470List.Create(AOwner: Tregistro_C460);
begin
  fOwner :=AOwner ;

end;

function Tregistro_C470List.Get(Index: Integer): Tregistro_C470;
begin
  Result :=Tregistro_C470(inherited Items[Index]) ;
end;

function Tregistro_C470List.IndexOf(const cod_item: string): Tregistro_C470;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if Self.Items[I].cod_item  =cod_item then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;

{ Tregistro_C490 }

function Tregistro_C490.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_icms,3,'000');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cfop);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.per_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_opr);
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_bc_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vl_icms,'0.00','0');
    Result	:=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_obs,6);
    Result	:=Result +Tefd_util.SEP_FIELD ;
end;

{ Tregistro_C490List }

function Tregistro_C490List.AddNew: Tregistro_C490;
begin
  Result	:=Tregistro_C490.Create('C490');
  Result.fOwner	:=Self	;
  inherited Add(Result) ;

  // registra nos totalizadores
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.DoInc();
  fOwner.fOwner.fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg) ;
end;

constructor Tregistro_C490List.Create(AOwner: Tregistro_C405);
begin
  inherited Create;
  fOwner :=AOwner ;
end;

function Tregistro_C490List.Get(Index: Integer): Tregistro_C490;
begin
  Result	:=Tregistro_C490(inherited Items[Index]);
end;

function Tregistro_C490List.IndexOf(const cst_icms, cfop: Word;
  const per_icms: Currency): Tregistro_C490;
var i:Integer	;
begin
    Result	:=nil	;
    for i :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[i] ;
        if(Result.cst_icms=cst_icms)and
          (Result.cfop    =cfop    )and
          (Result.per_icms=per_icms)then
        begin
          Break	;
        end
        else
          Result :=nil ;
    end;
end;

function Tregistro_C490List.vlr_icms: Currency;
var r_C490:Tregistro_C490;
var i:Integer	;
begin
    Result	:=0;
  	for i :=0 to Self.Count -1 do
    begin
        r_C490 :=Self.Items[i];
        Result :=Result +r_C490.vl_icms;
    end;
end;

end.
