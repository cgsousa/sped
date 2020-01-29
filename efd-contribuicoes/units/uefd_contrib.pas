{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              EFD-Contribuições (PIS/COFINS)                                  }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes e tipos para a geração da EFD-Contribuições ()
|
|Historico  Descrição
|*******************************************************************************
|16.08.2012 Cada bloco possui sua unit (antiga uefd_piscofins.pas mapeada units)
|20.12.2011 Versão inicial (Guia Prático EFD-PIS/COFINS – Versão 1.0.3
|                           Atualização: 01 de setembro de 2011)
*}

unit uefd_contrib;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon,
  uctrbloco_0,
  uctrbloco_A,
  uctrbloco_C,
  uctrbloco_D,
  uctrbloco_F,
  uctrbloco_M,
  uctrbloco_1;

{$REGION 'TEFD_Contrib'}
type
  TEFD_Contrib = class(TBaseEFD)
    IndTipEsc: TIndTypEsc;
    IndSitEsp: TIndSitEsp;
    Nome: string ;
    CNPJ: string ;
    UF: string ;
    CodMun: Integer ;
    IndNatPJ: TIndNatPJ ;
    IndTipAtv:TIndTypAtiv;
  private
    fBloco_0: TBloco_0;
    fBloco_1: TBloco_1;
    fBloco_9: TBloco_9;
    fBloco_A: TBloco_A;
    fBloco_C: TBloco_C;
    fBloco_D: TBloco_D;
    fBloco_F: TBloco_F;
    fBloco_M: TBloco_M;
  public
    const EFD_NAME = 'EFD-CONTRIBUIÇÕES';
  public
    procedure SetPesJur(const ACodVerLay: TCodVerLay;
                        const AIndTipEsc: TIndTypEsc;
                        const AIndSitEsp: TIndSitEsp;
                        const ADatIni: TDateTime;
                        const ADatFin: TDateTime;
                        const ANome: string ;
                        const ACNPJ: string ;
                        const AUF: string ;
                        const ACodMun: Integer ;
                        const AIndNatPJ: TIndNatPJ ;
                        const AIndTipAtv: TIndTypAtiv);
  public
    property Bloco_0: TBloco_0 read fBloco_0 ;//write fBloco_0;
    property Bloco_1: TBloco_1 read fBloco_1 ;//write fBloco_1;
    property Bloco_9: TBloco_9 read fBloco_9 ;
    property Bloco_A: TBloco_A read fBloco_A ;//write fBloco_A;
    property Bloco_C: TBloco_C read fBloco_C ;//write fBloco_C;
    property Bloco_D: TBloco_D read fBloco_D ;//write fBloco_D;
    property Bloco_F: TBloco_F read fBloco_F ;//write fBloco_F;
    property Bloco_M: TBloco_M read fBloco_M ;//write fBloco_M;

  public
    constructor Create();
    destructor Destroy; override;
    function Execute(AFileName: TFileName): Boolean; override;
  end;

{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;

{ TEFD_Contrib }

constructor TEFD_Contrib.Create;
begin
    inherited Create;
    fBloco_9 :=TBloco_9.Create;
    fBloco_0 :=TBloco_0.Create(fBloco_9);
    fBloco_C :=TBloco_C.Create(fBloco_9);
    fBloco_A :=TBloco_A.Create(fBloco_9);
    fBloco_D :=TBloco_D.Create(fBloco_9);
    fBloco_F :=TBloco_F.Create(fBloco_9);
    fBloco_M :=TBloco_M.Create(fBloco_9);
    fBloco_1 :=TBloco_1.Create(fBloco_9);
end;

destructor TEFD_Contrib.Destroy;
begin
    fBloco_0.Destroy;
    fBloco_A.Destroy;
    fBloco_C.Destroy;
    fBloco_D.Destroy;
    fBloco_F.Destroy;
    fBloco_M.Destroy;
    fBloco_1.Destroy;
    fBloco_9.Destroy;
    inherited Destroy;
end;

function TEFD_Contrib.Execute(AFileName: TFileName): Boolean;
begin
    Result :=inherited Execute(AFileName);
    try
        if Result then
        try
            Bloco_0.DoExec(FileEFD);
            Bloco_A.DoExec(FileEFD);
            Bloco_C.DoExec(FileEFD);
            Bloco_D.DoExec(FileEFD);
            Bloco_F.DoExec(FileEFD);
            Bloco_M.DoExec(FileEFD);
            Bloco_1.DoExec(FileEFD);
            Bloco_9.DoExec(FileEFD);
        except
            on E:EWriteError do
            begin
                Result :=False;
            end;
        end;
    finally
        if Assigned(FileEFD)then
        begin
            FileEFD.Destroy;
        end;
    end;
end;

procedure TEFD_Contrib.SetPesJur(const ACodVerLay: TCodVerLay;
                                 const AIndTipEsc: TIndTypEsc;
                                 const AIndSitEsp: TIndSitEsp;
                                 const ADatIni: TDateTime;
                                 const ADatFin: TDateTime;
                                 const ANome: string ;
                                 const ACNPJ: string ;
                                 const AUF: string ;
                                 const ACodMun: Integer ;
                                 const AIndNatPJ: TIndNatPJ ;
                                 const AIndTipAtv: TIndTypAtiv);
begin
    Bloco_0.registro_0000.cod_ver :=ACodVerLay;
    Bloco_0.registro_0000.tip_esc :=AIndTipEsc;
    Bloco_0.registro_0000.ind_sit_esp:=AIndSitEsp;
    Bloco_0.registro_0000.dt_ini :=StartOfTheMonth(ADatIni);
    Bloco_0.registro_0000.dt_fin :=EndOfTheMonth(ADatFin);
    Bloco_0.registro_0000.nome:=ANome ;
    Bloco_0.registro_0000.cnpj:=ACNPJ ;
    Bloco_0.registro_0000.uf  :=AUF ;
    Bloco_0.registro_0000.cod_mun   :=ACodMun ;
    Bloco_0.registro_0000.ind_nat_pj:=AIndNatPJ ;
    Bloco_0.registro_0000.ind_ativ  :=AIndTipAtv;
end;

end.
