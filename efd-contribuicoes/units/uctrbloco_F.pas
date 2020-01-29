{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              EFD-Contribuições (PIS/COFINS)                                  }
{              BLOCO A: DOCUMENTOS FISCAIS - SERVIÇOS (ISS)                    }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes/Objects e tipos para manipulação/tratar o
|   BLOCO F: DEMAIS DOCUMENTOS E OPERAÇÕES
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}
unit uctrbloco_F;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO F: DEMAIS DOCUMENTOS E OPERAÇÕES'}
type
  TBloco_F = class ;
  Tregistro_F010List = class ;
  Tregistro_F100List = class;

  {$REGION 'REGISTRO F001: ABERTURA DO BLOCO F'}
  Tregistro_F001 = class(TOpenBloco)
  private
    fOwner: TBloco_F;
  protected
    function GetRow: string; override	;
  public
    registro_F010: Tregistro_F010List;
    constructor Create(AOwner: TBloco_F);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO F010: IDENTIFICAÇÃO DO ESTABELECIMENTO'}
  Tregistro_F010 = class(TBaseRegistro)
  private
    fOwner: Tregistro_F010List;
  protected
    function GetRow: string; override ;
  public
    cnpj: string;
  public
    registro_F100: Tregistro_F100List ;
    constructor Create;
    destructor Destroy; override;
  end;

  Tregistro_F010List = class(TBaseEFDList)
  private
    fOwner: Tregistro_F001;
    function Get(Index: Integer): Tregistro_F010	;
  public
    property Items[Index: Integer]: Tregistro_F010 read Get;
    constructor Create(AOwner: Tregistro_F001);
    function AddNew: Tregistro_F010;
    function IndexOf(const cnpj: string): Tregistro_F010;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO F100: DEMAIS DOCUMENTOS E OPERAÇÕES GERADORAS DE CONTRIBUIÇÃO E CRÉDITOS'}
  Tregistro_F100 = class(TBaseRegistro)
  private
    fOwner: Tregistro_F100List;
  protected
    function GetRow: string; override ;
  public
    ind_oper: string ;
    cod_part: string ;
    cod_item: Integer;
    dt_oper: TDateTime;
    vl_oper: Currency;
    cst_pis: Byte ;
    vl_bc_pis: Currency;
    aliq_pis: Currency ;
    cst_cofins: Byte ;
    vl_bc_cofins: Currency;
    aliq_cofins: Currency;
    nat_bc_cred: string ;
    ind_orig_cred: string;
    cod_cta: string ;
    cod_ccus: string ;
    descr_doc: string;
    function vl_pis: Currency ;
    function vl_cofins: Currency;
  end;

  Tregistro_F100List = class(TList)
  private
    fOwner: Tregistro_F010;
    function Get(Index: Integer): Tregistro_F100	;
  public
    property Items[Index: Integer]: Tregistro_F100 read Get;
    constructor Create(AOwner: Tregistro_F010);
    function AddNew: Tregistro_F100;
    function IndexOf(const ind_oper: string ;
                     const cod_part: string ;
                     const cod_item: Integer;
                     const dt_oper: TDateTime): Tregistro_F100;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO F990: ENCERRAMENTO DO BLOCO F'}
  Tregistro_F990 = class(TBaseRegistro)
  private
    fOwner: TBloco_F;
  protected
    function GetRow: string; override;
  public
    qtd_lin_BF:Integer;
    constructor Create(AOwner: TBloco_F) ;
  end;
  {$ENDREGION}

  TBloco_F = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_F001: Tregistro_F001;
    registro_F990: Tregistro_F990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;

{ TBloco_F }

constructor TBloco_F.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9 ;
    registro_F001:=Tregistro_F001.Create(Self) ;
    registro_F990:=Tregistro_F990.Create(Self) ;
end;

destructor TBloco_F.Destroy;
begin
    registro_F001.Destroy ;
    registro_F990.Destroy ;
    inherited Destroy;
end;

procedure TBloco_F.DoExec(AFile: TFileEFD);
var
    I,J:Integer ;
var
    r_F010: Tregistro_F010 ;
    r_F100: Tregistro_F100 ;
begin
    AFile.NewLine(registro_F001.Row);
    for I :=0 to registro_F001.registro_F010.Count -1 do
    begin
        r_F010 :=registro_F001.registro_F010.Items[I];
        AFile.NewLine(r_F010.Row);
        for J :=0 to r_F010.registro_F100.Count -1 do
        begin
            r_F100 :=r_F010.registro_F100.Items[J];
            AFile.NewLine(r_F100.Row);
        end;
    end;
    AFile.NewLine(registro_F990.Row);
end;

procedure TBloco_F.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_F990.qtd_lin_BF, qtd_lin) ;
end;

{ Tregistro_F001 }

constructor Tregistro_F001.Create(AOwner: TBloco_F);
begin
    inherited Create('F001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
    registro_F010 :=Tregistro_F010List.Create(Self) ;
end;

destructor Tregistro_F001.Destroy;
begin
    registro_F010.Destroy ;
    inherited Destroy ;
end;

function Tregistro_F001.GetRow: string;
begin
    Result :=inherited GetRow ;
    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_F990 }

constructor Tregistro_F990.Create(AOwner: TBloco_F);
begin
    inherited Create('F990');
    fOwner :=AOwner ;
end;

function Tregistro_F990.GetRow: string;
begin
    Inc(Self.qtd_lin_BF);
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BF) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.Reg);
end;

{ Tregistro_F010List }

function Tregistro_F010List.AddNew: Tregistro_F010;
begin
    Result :=Tregistro_F010.Create ;
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    //registr anos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg);
end;

constructor Tregistro_F010List.Create(AOwner: Tregistro_F001);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_F010List.Get(Index: Integer): Tregistro_F010;
begin
    Result :=Tregistro_F010(inherited Items[Index]);
end;

function Tregistro_F010List.IndexOf(const cnpj: string): Tregistro_F010;
var
   I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        if Self.Items[I].cnpj = cnpj then
        begin
            Result :=Self.Items[I] ;
            Result.Status :=rsRead ;
            Break ;
        end;
    end;
end;


{ Tregistro_F010 }

constructor Tregistro_F010.Create;
begin
    inherited Create('F010');
    registro_F100 :=Tregistro_F100List.Create(Self) ;
end;

destructor Tregistro_F010.Destroy;
begin
    registro_F100.Destroy ;
    inherited Destroy ;
end;


function Tregistro_F010.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cnpj,14) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Self.Reg);
end;

{ Tregistro_F100List }

function Tregistro_F100List.AddNew: Tregistro_F100;
begin
    Result :=Tregistro_F100.Create('F100') ;
    Result.fOwner :=Self ;
    Result.Status :=rsNew;
    inherited Add(Result);
    //resgistra nos toralizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.Reg);
end;

constructor Tregistro_F100List.Create(AOwner: Tregistro_F010);
begin
    inherited Create();
    fOwner :=AOwner;
end;

function Tregistro_F100List.Get(Index: Integer): Tregistro_F100;
begin
    Result :=Tregistro_F100(inherited Items[Index]);
end;

function Tregistro_F100List.IndexOf(const ind_oper, cod_part: string;
  const cod_item: Integer;
  const dt_oper: TDateTime): Tregistro_F100;
var
   I:Integer ;
begin
    Result :=nil ;
    for I :=0 to Self.Count -1 do
    begin
        Result :=Self.Items[I] ;
        if(Result.ind_oper = ind_oper)and
          (Result.cod_part = cod_part)and
          (Result.cod_item = cod_item)and
          (Result.dt_oper = dt_oper)then
        begin
            Result.Status :=rsRead ;
            Break ;
        end
        else begin
            Result :=nil ;
        end;
    end;
end;

{ Tregistro_F100 }

function Tregistro_F100.GetRow: string;
begin
		Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Self.ind_oper;
    Result  :=Result +Tefd_util.SEP_FIELD +Self.cod_part;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_item);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dt_oper);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_oper);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_pis,2);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_pis);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_pis,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_pis);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cst_cofins,2);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_bc_cofins);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.aliq_cofins,'0.0000');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vl_cofins);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.nat_bc_cred,2,True);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.ind_orig_cred,1);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_cta,60);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_ccus,60);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.descr_doc,60);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_F100.vl_cofins: Currency;
begin
    Result :=(Self.vl_bc_cofins * Self.aliq_cofins)/100 ;
end;

function Tregistro_F100.vl_pis: Currency;
begin
    Result :=(Self.vl_bc_pis * Self.aliq_pis)/100 ;
end;



end.
