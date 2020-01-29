{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              EFD-Contribuições (PIS/COFINS)                                  }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes/Objects e tipos para criar, manipular e tratar o
|   BLOCO 1: COMPLEMENTO DA ESCRITURAÇÃO – CONTROLE DE SALDOS DE CRÉDITOS E DE
|   RETENÇÕES, OPERAÇÕES EXTEMPORÂNEAS E OUTRAS INFORMAÇÕES
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}

unit uctrbloco_1;

interface
uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon;

{$REGION 'BLOCO 1: COMPLEMENTO DA ESCRITURAÇÃO – CONTROLE DE SALDOS DE CRÉDITOS
E DE RETENÇÕES, OPERAÇÕES EXTEMPORÂNEAS E OUTRAS INFORMAÇÕES'}
type
  TBloco_1 = class ;
//  Tregistro_1010 = class;

  {$REGION 'REGISTRO 1001: ABERTURA DO BLOCO 1'}
  Tregistro_1001 = class(TOpenBloco)
  private
    fOwner: TBloco_1;
  protected
    function GetRow: string; override ;
  public
//    registro_1010: Tregistro_1010;
    constructor Create(AOwner: TBloco_1);
    destructor Destroy; override	;
  end;
  {$ENDREGION}



  {$REGION 'REGISTRO 1990: ENCERRAMENTO DO BLOCO 1'}
  Tregistro_1990 = class(TBaseRegistro)
  private
    fOwner: TBloco_1;
  protected
    function GetRow: string; override ;
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
    constructor Create(ABloco_9: TBloco_9); reintroduce ;
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
//    AFile.NewLine(registro_1001.registro_1010.Row);
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
    ind_mov :=movNoDat;
//    registro_1010 :=Tregistro_1010.Create(Self);
end;

destructor Tregistro_1001.Destroy;
begin
//    registro_1010.Destroy ;
    inherited;
end;

function Tregistro_1001.GetRow: string;
begin
    Result :=inherited GetRow ;
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

end.
