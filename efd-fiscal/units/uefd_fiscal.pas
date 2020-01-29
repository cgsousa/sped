{******************************************************************************}
{                                                                              }
{              SPED Sistema Publico de Escrituracao Digital                    }
{              SPED Fiscal                                                     }
{              Copyright (c) 1992,2012 Suporteware                             }
{              Created by Carlos Gonzaga                                       }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|   Classes/Objects e tipos para criar e manipular a EFD Fiscal
|
|Historico  Descrição
|*******************************************************************************
|07.12.2010	Versão inicial Guia Prático EFD – Versão 2.0.4
|05.05.2011	Adaptado para o estoque
|01.06.2012  Unificação das classes comuns e com base no Guia Prático EFD -
|            Versão 2.0.8 Atualização: março de 2012
*}
unit uefd_fiscal;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ,
  EFDCommon,
  ufisbloco_0,
  ufisbloco_C,
  ufisbloco_D,
  ufisbloco_E,
  ufisbloco_G,
  ufisbloco_H,
  ufisbloco_K,
  ufisbloco_1;

{$REGION 'TEFD_Fiscal'}
type
//  TSpedFiscal = class
  TEFD_Fiscal = class(TBaseEFD)
    CodFinaly: TCodFinaly;
    Perfil: TPerfil;
  private
    fBloco_0: TBloco_0;
    fBloco_C: TBloco_C;
    fBloco_D: TBloco_D;
    fBloco_E: TBloco_E;
    fBloco_G: TBloco_G;
    fBloco_H: TBloco_H;
    fBloco_K: TBloco_K;
    fBloco_1: TBloco_1;
    fBloco_9: TBloco_9;
    procedure DoFillBE;

  public
    const EFD_NAME = 'EFD-ICMS/IPI';

  public
    procedure SetEntidade(
      //registro_0000
      const cod_ver: TCodVerLay	;
      const cod_fin: TCodFinaly;
      const dta_ini: TDateTime;
      const dta_fin: TDateTime;
      const ind_perfil: TPerfil;
      const ind_ativ: TIndAtiv ;
      const nome_emp: string;
      const cnpj: string ;
      const uf: string;
      const ins_est: string	;
      const cod_mun: Integer;
      //registro_0005
      const cep: string  ;
      const endere: string ;
      const bairro: string ;
      const fone  : string);

    procedure SetContab(const nome, cpf, crc, cnpj: string;
      const cep, endere, bairro, fone, email: string;
      const cod_mun : Integer);

  public
    property Bloco_0: TBloco_0 read fBloco_0;// write fBloco_0 ;
    property Bloco_C: TBloco_C read fBloco_C;// write fBloco_C ;
    property Bloco_D: TBloco_D read fBloco_D;// write fBloco_D ;
    property Bloco_E: TBloco_E read fBloco_E;// write fBloco_E ;
    property Bloco_G: TBloco_G read fBloco_G;// write fBloco_G ;
    property Bloco_H: TBloco_H read fBloco_H;// write fBloco_H ;
    property Bloco_K: TBloco_K read fBloco_K;// write fBloco_K ;
    property Bloco_1: TBloco_1 read fBloco_1;// write fBloco_1 ;
    property Bloco_9: TBloco_9 read fBloco_9;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute(AFileName: TFileName): Boolean ;
    procedure DoLoadFromFile(const AFileName: TFileName);
  end;
{$ENDREGION}


implementation

uses DateUtils, StrUtils,
  EFDUtils ;

{ TSped_Fiscal }

constructor TEFD_Fiscal.Create;
begin
    inherited Create ;
    fBloco_9 :=TBloco_9.Create;
    fBloco_0 :=TBloco_0.Create(Self.fBloco_9);
    fBloco_C :=TBloco_C.Create(Self.fBloco_9);
    fBloco_D :=TBloco_D.Create(Self.fBloco_9);
    fBloco_E :=TBloco_E.Create(Self.fBloco_9);
    fBloco_G :=TBloco_G.Create(Self.fBloco_9);
    fBloco_H :=TBloco_H.Create(Self.fBloco_9);
    fBloco_K :=TBloco_K.Create(Self.fBloco_9);
    fBloco_1 :=TBloco_1.Create(Self.fBloco_9);
end;

destructor TEFD_Fiscal.Destroy;
begin
    fBloco_0.Destroy;
    fBloco_C.Destroy;
    fBloco_D.Destroy;
    fBloco_E.Destroy;
    fBloco_G.Destroy;
    fBloco_H.Destroy;
    fBloco_K.Destroy;
    fBloco_1.Destroy;
    fBloco_9.Destroy;
    inherited Destroy;
end;

procedure TEFD_Fiscal.DoFillBE;
var
  	r_0150: Tregistro_0150;
		r_C100: Tregistro_C100;
    r_C190: Tregistro_C190;
    r_C400: Tregistro_C400;
    r_C405: Tregistro_C405;
    r_C490: Tregistro_C490;

    r_D100: Tregistro_D100;
    r_D190: Tregistro_D190;
var
    r_E100: Tregistro_E100;
    r_E116: Tregistro_E116;
    r_E200: Tregistro_E200;
var
		I,J,K: Integer;
var
    vlr_st: Currency;
    UF: string ;

begin

    Bloco_E.DoInit(Bloco_0.dta_ini, Bloco_0.dta_fin);
    r_E100 :=Bloco_E.registro_E001.registro_E100.Items[0];

    {Ler docs´ do BLOCO C}
    for I :=0 to Bloco_C.registro_C001.registro_C100.Count -1 do
    begin
        r_C100 :=Bloco_C.registro_C001.registro_C100.Items[I];
        case r_C100.ind_oper of
            toEnt: // crédito de ICMS
            for J :=0 to r_C100.registro_C190.Count -1 do
            begin
                r_C190 :=r_C100.registro_C190.Items[J];
                // O valor deve ser igual à soma do campo VL_ICMS do reg.C190
                // para CFOP iniciado por 1 (exceto 1605), 2, 3 e CFOP 5605.
                if r_C190.cfop = 1605 then
                begin
                    Continue ;
                end;
                if(IntToStr(r_C190.cfop)[1]in['1','2','3'])or(r_C190.cfop=5605) then
                begin
          	        r_E100.registro_E110.vlr_tot_creditos :=
                    r_E100.registro_E110.vlr_tot_creditos +r_C190.vl_icms;
                end;
            end;

            toSai: // débito de ICMS
            begin
                //Tefd_util.IncValue(r_E100.registro_E110.vlr_tot_debitos,
                //									 r_C100.registro_C190.vlr_icms);
                r_E100.registro_E110.vlr_tot_debitos :=
                r_E100.registro_E110.vlr_tot_debitos +r_C100.registro_C190.vlr_icms;
            end;
        end;

        vlr_st :=r_C100.vl_icmsst;
        if vlr_st > 0 then
        begin
            r_0150 :=Bloco_0.GetReg_0150(r_C100.cod_part) ;
            if r_0150<>nil then
            begin
                UF :=Tefd_util.GetUFSigla(r_0150.cod_mun) ;
                r_E200 :=Bloco_E.registro_E001.registro_E200.IndexOf(UF) ;
                if r_E200 = nil then
                begin
                  	r_E200  :=Bloco_E.registro_E001.registro_E200.AddNew;
                    r_E200.uf :=UF ;
                    r_E200.dt_ini :=r_E100.dt_ini;
                    r_E200.dt_fin :=r_E100.dt_fin;
              	end;

                r_E200.registro_E210.ind_mov_st 			 :=mstComST;
                r_E200.registro_E210.vl_sld_cre_ant_st :=0.00;

                for J :=0 to r_C100.registro_C190.Count -1 do
                begin
                    r_C190 :=r_C100.registro_C190.Items[J]	;
                    if Tefd_util.CFOP_In(r_C190.cfop,[1410,1411,1414,1415,1660,1661,1662,2410,2411,2414,2415,2660,2661,2662]) then
                    begin
                        r_E200.registro_E210.vl_devol_st :=r_E200.registro_E210.vl_devol_st +
                                                           r_C190.vl_icms_st	;
                    end;

                    if not Tefd_util.CFOP_In(r_C190.cfop,[1410,1411,1414,1415,1660,1661,1662,2410,2411,2414,2415,2660,2661,2662]) then
                    begin
                        if (IntToStr(r_C190.cfop)[1] in['1','2']) then
                        begin
                            r_E200.registro_E210.vl_out_cre_st :=
                            r_E200.registro_E210.vl_out_cre_st +
                            r_C190.vl_icms_st	;
                        end;
                    end;

                    if (IntToStr(r_C190.cfop)[1] in['5','6']) then
                    begin
                        r_E200.registro_E210.vl_ret_st :=
                        r_E200.registro_E210.vl_ret_st +
                        r_C190.vl_icms_st;
                    end;

                end;

            end;

        end;

    end;

    for I :=0 to Bloco_C.registro_C001.registro_C400.Count -1 do
    begin
        r_C400 :=Bloco_C.registro_C001.registro_C400.Items[I];
        for J :=0 to r_C400.registro_C405.Count -1 do
        begin
          r_C405 :=r_C400.registro_C405.Items[J];
          for K := 0 to r_C405.registro_C490.Count - 1 do
          begin
            r_C490 :=r_C405.registro_C490.Items[K];
            // O valor deve ser igual à soma do campo VL_ICMS do reg.C490
            // para CFOP iniciado por 5, 6, 7 e 1605.
            if(IntToStr(r_C490.cfop)[1]in['5','6','7'])or(r_C490.cfop=1605)then
            begin
              r_E100.registro_E110.vlr_tot_debitos :=
              r_E100.registro_E110.vlr_tot_debitos +r_C490.vl_icms;
            end;

          end;

        end;
    end;

    {Ler docs´ do BLOCO D}
    for I :=0 to Bloco_D.registro_D001.registro_D100.Count -1 do
    begin
        r_D100 :=Bloco_D.registro_D001.registro_D100.Items[I];
        r_D190 :=r_D100.registro_D190.Items[0] ;
        // O valor deve ser igual à soma do campo VL_ICMS do reg.D190
        // para CFOP iniciado por 1 (exceto 1605), 2, 3 e CFOP 5605.
        if(IntToStr(r_D190.cfop)[1]in['1','2','3'])and(r_D190.cfop<>1605)or
          (r_D190.cfop=5605) then
        begin
            r_E100.registro_E110.vlr_tot_creditos :=
            r_E100.registro_E110.vlr_tot_creditos + r_D190.vl_icms;
        end;
    end;


    r_E116 :=r_E100.registro_E110.registro_E116.Items[0] ;
    if r_E116<>nil then
    begin
        r_E116.vlr_obg	:=r_E100.registro_E110.vlr_icms_recolh +
                        	r_E100.registro_E110.vlr_deb_esp;
    end;
end;

procedure TEFD_Fiscal.DoLoadFromFile(const AFileName: TFileName);
begin
  //
end;

function TEFD_Fiscal.Execute(AFileName: TFileName): Boolean;
begin
    Result :=inherited Execute(AFileName);
    try
        try
            //
            DoFillBE;
            //
            Bloco_0.DoExec(FileEFD);
            Bloco_C.DoExec(FileEFD);
            Bloco_D.DoExec(FileEFD);
            Bloco_E.DoExec(FileEFD);
            Bloco_G.DoExec(FileEFD);
            Bloco_H.DoExec(FileEFD);
            Bloco_K.DoExec(FileEFD);
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

procedure TEFD_Fiscal.SetContab(const nome, cpf, crc, cnpj: string ;
                                const cep, endere, bairro, fone, email: string;
                                const cod_mun : Integer);
begin
    Bloco_0.registro_0001.registro_0100.nome  :=nome ;
    Bloco_0.registro_0001.registro_0100.cpf   :=cpf ;
    Bloco_0.registro_0001.registro_0100.crc   :=crc ;
    Bloco_0.registro_0001.registro_0100.cnpj  :=cnpj ;
    Bloco_0.registro_0001.registro_0100.cep   :=cep ;
    Bloco_0.registro_0001.registro_0100.endere:=endere ;
    Bloco_0.registro_0001.registro_0100.bairro:=bairro ;
    Bloco_0.registro_0001.registro_0100.fone  :=fone ;
    Bloco_0.registro_0001.registro_0100.email :=email ;
    Bloco_0.registro_0001.registro_0100.cod_mun :=cod_mun ;
end;

procedure TEFD_Fiscal.SetEntidade(const cod_ver: TCodVerLay;
                                    const cod_fin: TCodFinaly;
                                    const dta_ini, dta_fin: TDateTime;
                                    const ind_perfil: TPerfil;
                                    const ind_ativ: TIndAtiv;
                                    const nome_emp, cnpj, uf, ins_est: string;
                                    const cod_mun: Integer;
                                    const cep, endere, bairro, fone: string);
begin
    Bloco_0.registro_0000.cod_ver :=cod_ver;
    Bloco_0.registro_0000.cod_fin :=cod_fin;
    Bloco_0.registro_0000.dta_ini :=StartOfTheMonth(dta_ini);
    Bloco_0.registro_0000.dta_fin :=EndOfTheMonth(dta_fin);
    Bloco_0.registro_0000.nome    :=nome_emp;
    Bloco_0.registro_0000.cnpj    :=cnpj;
    Bloco_0.registro_0000.uf      :=uf;
    Bloco_0.registro_0000.ie      :=ins_est ;
    Bloco_0.registro_0000.cod_mun :=cod_mun ;
    Bloco_0.registro_0000.ind_perfil :=ind_perfil;
    Bloco_0.registro_0000.ind_ativ   :=ind_ativ;

    Bloco_0.registro_0001.registro_0005.fantazia:=nome_emp;
    Bloco_0.registro_0001.registro_0005.cep     :=cep ;
    Bloco_0.registro_0001.registro_0005.log_end :=endere;
    Bloco_0.registro_0001.registro_0005.bairro  :=bairro;
    Bloco_0.registro_0001.registro_0005.fone    :=fone ;
end;

end.
