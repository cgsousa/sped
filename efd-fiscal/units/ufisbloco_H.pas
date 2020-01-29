{*****************************************************************************}
{                                                                             }
{              SPED Sistema Publico de Escrituracao Digital                   }
{              SPED Fiscal                                                    }
{              Copyright (c) 1992,2012                                        }
{              Created by Carlos Gonzaga                                      }
{                                                                             }
{*****************************************************************************}

{******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO H: INVENTÁRIO FÍSICO
|
|Historico  Descrição
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Versão inicial (Guia Prático EFD – Versão 2.0.2	Atualização:
|                           08 de setembro de 2010)
*}
unit ufisbloco_H;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  Contnrs ,
  EFDCommon;

type
  {Indicador de propriedade/posse do item:}
  TIndPropItem = (
    piInfoSeuPoder, // 0- Item de propriedade do informante e em seu poder;
    piInfoPosseTer, // 1- Item de propriedade do informante em posse de terceiros;
    piTerPosseInfo  // 2- Item de propriedade de terceiros em posse do informante
    );

  {Motivo do Inventário}
  TInvMotivo =(
    motFimPeriodo=1,  //01 – No final no período;
    motICMS=2,        //02 – Na mudança de forma de tributação da mercadoria (ICMS);
    motBaixaCad=3,    //03 – Na solicitação da baixa cadastral, paralisação temporária e outras situações;
    motAltRegimePg=4, //04 – Na alteração de regime de pagamento – condição do contribuinte;
    motDetFisco=5     //05 – Por determinação dos fiscos.
    );

{$REGION 'BLOCO H: INVENTÁRIO FÍSICO'}
type
  TBloco_H = class ;
  Tregistro_H005 = class;
  Tregistro_H005List = class;
  Tregistro_H010List = class;
  Tregistro_H010 = class;

  {$REGION 'REGISTRO H001: ABERTURA DO BLOCO H'}
  Tregistro_H001 = class(TOpenBloco)
  private
    fOwner: TBloco_H;
  protected
    function GetRow: string; override ;
  public
    registro_H005: Tregistro_H005List ;
    constructor Create(AOwner: TBloco_H);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO H005: TOTAIS DO INVENTÁRIO'}
  Tregistro_H005 = class(TBaseRegistro)
  private
    fOwner: Tregistro_H005List ;
  protected
    function GetRow: string; override ;
  public
    dta_inv: TDateTime	;
    function vlr_inv: Currency;
  public
    mot_inv: TInvMotivo;
    registro_H010: Tregistro_H010List;
    constructor Create;
  end;

  Tregistro_H005List = class(TBaseEFDList)
  private
    fOwner: Tregistro_H001;
    function Get(Index: Integer): Tregistro_H005;
  public
    constructor Create(AOwner: Tregistro_H001);
    property Items[Index: Integer]: Tregistro_H005 read Get;
    function AddNew: Tregistro_H005;
    function IndexOf(const dta_iven: TDateTime): Tregistro_H005;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO H010: INVENTÁRIO'}
  Tregistro_H010 = class(TBaseRegistro)
  private
    fOwner: Tregistro_H010List;
  protected
    function GetRow: string; override ;
  public
    cod_item    :Integer; // Código do item (campo 02 do Registro 0200)
    und_item    :string	; // Unidade do item
    qtd_item    :Currency;// Quantidade do item
    vlr_unit    :Currency;// Valor unitário do item
    vlr_tot     :Currency;// Valor do item
    ind_prop    :TIndPropItem ;
    cod_part    :string	;// Código do participante (campo 02 do Registro 0150)
    des_compl 	:string	;// Descrição complementar
    cod_cta     :string	;// Código da conta analítica contábil debitada/creditada
//    function vlr_tot  :Currency ;
  end;

  Tregistro_H010List = class(TBaseEFDList)
  private
    fOwner: Tregistro_H005;
    function Get(Index: Integer): Tregistro_H010	;
  public
    property Items[Index: Integer]: Tregistro_H010 read Get;
    function AddNew: Tregistro_H010;
    function IndexOf(const cod_item: Integer): Tregistro_H010;
  public
    constructor Create(AOwner: Tregistro_H005);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO H990: ENCERRAMENTO DO BLOCO H'}
  Tregistro_H990 = class
  private
    const reg = 'H990' ;
  private
    fOwner: TBloco_H;
    function Row: string;
  public
    qtd_lin_BH:Integer;
    constructor Create(AOwner: TBloco_H) ;
  end;
  {$ENDREGION}

  TBloco_H = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_H001: Tregistro_H001;
    registro_H990: Tregistro_H990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD) ;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_H }

constructor TBloco_H.Create(ABloco_9: TBloco_9);
begin
    inherited Create();
    fBloco_9 :=ABloco_9;
    registro_H001 :=Tregistro_H001.Create(Self) ;
    registro_H990 :=Tregistro_H990.Create(Self) ;
end;

destructor TBloco_H.Destroy;
begin
    registro_H001.Destroy;
    registro_H990.Destroy;
    inherited Destroy;
end;

procedure TBloco_H.DoExec(AFile: TFileEFD);
var
    I,J:Integer	;
var
    r_H005:Tregistro_H005	;
    r_H010:Tregistro_H010	;
begin
    AFile.NewLine(registro_H001.Row);
    for I :=0 to registro_H001.registro_H005.Count -1 do
    begin
        r_H005 :=registro_H001.registro_H005.Items[I] ;
        AFile.NewLine(r_H005.Row);
        for J :=0 to r_H005.registro_H010.Count -1 do
        begin
            r_H010 :=r_H005.registro_H010.Items[J] ;
            AFile.NewLine(r_H010.Row);
        end;
    end;
    AFile.NewLine(registro_H990.Row)	;
end;

procedure TBloco_H.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_H990.qtd_lin_BH, qtd_lin) ;
end;

{ Tregistro_H001 }

constructor Tregistro_H001.Create(AOwner: TBloco_H);
begin
    inherited Create('H001');
    fOwner :=AOwner ;
    ind_mov:=movNoDat ;
    registro_H005 :=Tregistro_H005List.Create(Self);
end;

destructor Tregistro_H001.Destroy;
begin
    registro_H005.Destroy;
    inherited Destroy ;
end;

function Tregistro_H001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0') ;
//    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_H990 }

constructor Tregistro_H990.Create(AOwner: TBloco_H);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_H990.Row: string;
begin
    Inc(Self.qtd_lin_BH);
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_BH) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_H005List }

function Tregistro_H005List.AddNew: Tregistro_H005;
begin
    Result :=Tregistro_H005.Create;
    Result.fOwner:=Self	;
    inherited Add(Result);

    //indicador de movimento
    fOwner.ind_mov :=movDat;

    // registra nos totalizadores
    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_H005List.Create(AOwner: Tregistro_H001);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_H005List.Get(Index: Integer): Tregistro_H005;
begin
    Result :=Tregistro_H005(inherited Items[Index]);
end;

function Tregistro_H005List.IndexOf(const dta_iven: TDateTime): Tregistro_H005;
var
    I:Integer;
begin
    Result:=nil;
    for I :=0 to Self.Count -1 do
    begin
      if Self.Items[I].dta_inv=dta_iven then
      begin
          Result	:=Self.Items[I];
          Break;
      end;
    end;
end;


{ Tregistro_H005 }

constructor Tregistro_H005.Create;
begin
    inherited Create('H005');
    registro_H010 :=Tregistro_H010List.Create(Self);
    mot_inv :=motFimPeriodo;
end;

function Tregistro_H005.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FDat(Self.dta_inv) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_inv,'0');
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.mot_inv),2);
    Result :=Result +Tefd_util.SEP_FIELD ;
end;

function Tregistro_H005.vlr_inv: Currency;
var i:Integer;
begin
    Result:=0;
    for i :=0 to Self.registro_H010.Count -1 do
    begin
    		Result	:=Result +Self.registro_H010.Items[i].vlr_tot	;
    end;
end;

{ Tregistro_H010List }

function Tregistro_H010List.AddNew: Tregistro_H010;
begin
    Result  :=Tregistro_H010.Create('H010');
    Result.fOwner:=Self	;
    inherited Add(Result);

    // registra nos totalizadores
    fOwner.fOwner.fOwner.fOwner.DoInc();
    fOwner.fOwner.fOwner.fOwner.fBloco_9.UpdateReg(Result.reg) ;
end;

constructor Tregistro_H010List.Create(AOwner: Tregistro_H005);
begin
    inherited Create();
    fOwner :=AOwner ;
end;

function Tregistro_H010List.Get(Index: Integer): Tregistro_H010;
begin
    Result :=Tregistro_H010(inherited Items[Index]);
end;

function Tregistro_H010List.IndexOf(const cod_item: Integer): Tregistro_H010;
var i:Integer;
begin
    Result:=nil;
    for i :=0 to Self.Count -1 do
    begin
      if Self.Items[i].cod_item=cod_item then
      begin
          Result	:=Self.Items[i];
          Break;
      end;
    end;
end;

{ Tregistro_H010 }

function Tregistro_H010.GetRow: string;
begin
    Result  :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.cod_item)	;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.und_item,6)	;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.qtd_item,'0.000','0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FFlt(Self.vlr_unit,'0.000000','0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FCur(Self.vlr_tot,'0')	;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_prop),1,'0');
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_part,10)	;
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.des_compl,60);
    Result  :=Result +Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.cod_cta,8);
    Result  :=Result +Tefd_util.SEP_FIELD ;
end;

end.
