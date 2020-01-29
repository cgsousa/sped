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
|   BLOCO 1: OUTRAS INFORMA��ES
|
|Historico  Descri��o
|******************************************************************************
|01.06.2012 Cada bloco possui sua unit (antiga uefd.pas mapeada para varias...)
|05.05.2011 Adaptado para o estoque
|07.12.2010 Vers�o inicial (Guia Pr�tico EFD � Vers�o 2.0.2	Atualiza��o:
|                           08 de setembro de 2010)
*}
unit ufisbloco_1;

interface
uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO 1: OUTRAS INFORMA��ES'}
type
  TBloco_1 = class ;
  Tregistro_1010 = class;

  {$REGION 'REGISTRO 1001: ABERTURA DO BLOCO 1'}
  Tregistro_1001 = class(TOpenBloco)
  private
    fOwner: TBloco_1;
  protected
    function GetRow: string; override ;
  public
    //const reg = '1001' ;
  public
    registro_1010: Tregistro_1010;
    constructor Create(AOwner: TBloco_1);
    destructor Destroy; override	;
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 1010: OBRIGATORIEDADE DE REGISTROS DO BLOCO 1'}
  Tregistro_1010 = class(TBaseRegistro)
  private
    fOwner: Tregistro_1001;
  protected
    function GetRow: string; override ;
  public
//    const reg = '1010';
    ind_exp: Boolean ; //Reg. 1100 - Ocorreu averba��o (conclus�o) de exporta��o no per�odo:
    ind_ccrf: Boolean; //Reg 1200 � Existem informa��es acerca de cr�ditos de ICMS a
                       //serem controlados, definidos pela Sefaz
    ind_comb: Boolean; //Reg. 1300 � � comercio varejista de combust�veis
    ind_usina: Boolean;//Reg. 1390 � Usinas de a��car e/�lcool � O estabelecimento �
                       //produtor de a��car e/ou �lcool carburante
    ind_va: Boolean; //Reg 1400 � Existem informa��es a serem prestadas neste
                     //registro e o registro � obrigat�rio em sua Unidade da Federa��o
    ind_ee: Boolean; //Reg 1500 - A empresa � distribuidora de energia e ocorreu
                     //fornecimento de energia el�trica para consumidores de outra UF
    ind_cart: Boolean; //Reg 1600 - Realizou vendas com Cart�o de Cr�dito ou de d�bito
    ind_form: Boolean; //Reg 1700 - � obrigat�rio em sua unidade da federa��o o
                       //controle de utiliza��o de documentos fiscais em papel
    ind_aer: Boolean; //Reg 1800 � A empresa prestou servi�os de transporte a�reo
                      //de cargas e de passageiros:
  public
    constructor Create(AOwner: Tregistro_1001);
  end;
  {$ENDREGION}

  {$REGION 'REGISTRO 1990: ENCERRAMENTO DO BLOCO 1'}
  Tregistro_1990 = class(TBaseRegistro)
  private
    fOwner: TBloco_1;
  protected
    function GetRow: string; override ;
//    const reg = '1990' ;
  public
    qtd_lin_B1:Integer;
    constructor Create(AOwner: TBloco_1) ;
  end;
  {$ENDREGION}

  TBloco_1 = class
  private
    fBloco_9: TBloco_9 ;
    procedure DoInc(const qtd_lin: Integer=1) ;
  public
    registro_1001: Tregistro_1001;
    registro_1990: Tregistro_1990;
  public
    constructor Create(ABloco_9: TBloco_9);
    destructor Destroy; override;
    procedure DoExec(AFile: TFileEFD);
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;


{ TBloco_1 }

constructor TBloco_1.Create(ABloco_9: TBloco_9);
begin
    inherited Create;
    fBloco_9 :=ABloco_9 ;
    registro_1001:=Tregistro_1001.Create(Self);
    registro_1990:=Tregistro_1990.Create(Self);
end;

destructor TBloco_1.Destroy;
begin
    registro_1001.Destroy;
    registro_1990.Destroy;
    inherited Destroy;
end;

procedure TBloco_1.DoExec(AFile: TFileEFD);
begin
    AFile.NewLine(registro_1001.Row);
    AFile.NewLine(registro_1001.registro_1010.Row);
    AFile.NewLine(registro_1990.Row);
end;

procedure TBloco_1.DoInc(const qtd_lin: Integer);
begin
    Inc(Self.registro_1990.qtd_lin_B1, qtd_lin);

end;

{ Tregistro_1001 }

constructor Tregistro_1001.Create(AOwner: TBloco_1);
begin
    inherited Create('1001');
    fOwner :=AOwner ;
    ind_mov :=movDat;
    registro_1010 :=Tregistro_1010.Create(Self);
end;

destructor Tregistro_1001.Destroy;
begin
    registro_1010.Destroy ;
    inherited;
end;

function Tregistro_1001.GetRow: string;
begin
    Result :=inherited GetRow ;
//    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
//    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Ord(Self.ind_mov),1,'0');
//    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.DoInc();
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_1990 }

constructor Tregistro_1990.Create(AOwner: TBloco_1);
begin
    inherited Create('1990');
    fOwner :=AOwner ;
end;

function Tregistro_1990.GetRow: string;
begin
    Inc(Self.qtd_lin_B1);
    Result :=        Tefd_util.SEP_FIELD +Tefd_util.FStr(Self.reg) ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FInt(Self.qtd_lin_B1) ;
    Result :=Result +Tefd_util.SEP_FIELD ;
    fOwner.fBloco_9.UpdateReg(Self.reg);
end;

{ Tregistro_1010 }

constructor Tregistro_1010.Create(AOwner: Tregistro_1001);
begin
    inherited Create('1010');
    fOwner :=AOwner ;
end;

function Tregistro_1010.GetRow: string;
begin
    Result :=        Tefd_util.SEP_FIELD +Self.reg ;
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_exp);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_ccrf);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_comb);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_usina);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_va);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_ee);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_cart);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_form);
    Result :=Result +Tefd_util.SEP_FIELD +Tefd_util.FBoo(Self.ind_aer);
    Result :=Result +Tefd_util.SEP_FIELD;

    fOwner.fOwner.DoInc();
    fOwner.fOwner.fBloco_9.UpdateReg(Self.reg);
end;

end.
