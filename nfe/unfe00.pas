unit unfe00;

interface

{$REGION 'Uses'}
uses
    Windows ,
    Messages,
    SysUtils,
    Variants,
    Classes ,
    Contnrs ,
    Graphics,
    Controls,
    Dialogs ,
    funcoes ,
    uclass  ,
    udbz    ,
    ucls    ,
    unetfun	,
    unfexml ,
    unfews  ,
    unfeutil,
    unfe01  ,
    udanfe  ,
    urave ,
    RpDefine;
{$ENDREGION}


{$REGION 'Tnfecoderr00List'}
type
      Tnfecoderr = record
          fErrCod: Integer;
          fErrMsg: string;
      end;

      Tnfecoderr00List = class(TList)
      type  Tnfecoderr00 = class
            private
                Index : Integer;
                Parent: Tnfecoderr00List;
                err00_codigo: Word;
                err00_descri: string;
            end;
      private
          function Get(Index: Integer): Tnfecoderr00;
          function IndexOf(err00_codigo: Word): Tnfecoderr00;
          function CreateNew: Tnfecoderr00;
          procedure Load;
      public
          property Items[index: Integer]: Tnfecoderr00 read Get;
          function IndexOfByCod(err00_codigo: Word): string;
          constructor Create;
          destructor Destroy;override;
      end;
{$ENDREGION}


type
  Tcatalog_table = class
  public
    const catalog_cs='cs01estoque';
    const catalog_df='df01estoque';
    const catalog_em='em01estoque';
    const catalog_if='if01estoque';
    const catalog_pm='pm01estoque';
  end;

type
  Testtipfis01List = class;
  Testtipfis01 = class
  private
    fOwner :Testtipfis01List;
  public
    codfis: Integer ;
    aliq_icms: Currency;
    vlr_bc_icms: Currency;
    vlr_icms: Currency;
    vlr_tot: Currency;
    msg_01:string;
    msg_02:string;
    msg_03:string;
  end;

  Testtipfis01List = class(TObjectList)
  private
    function Get(Index: Integer): Testtipfis01;
  public
    PesFis: Boolean;
    OpeInt: Boolean;
    property Items[Index:Integer]: Testtipfis01 read Get;
    function IndexOf(const codfis:Integer; const aliq_icms: Currency): Testtipfis01;
    function AddNew: Testtipfis01;
    procedure Load(const codfil, codntf, codtyp: Integer);
    procedure LoadMsg(const codfil, codntf, codtyp: Integer);
  end;


{$REGION 'Testnfelot00List'}
type
  Testnfelot00Stt=(enlNSend,enlYSend,enlCancel);

  TFilterLot = record
      cfil: Integer;
      lot1,lot2: Integer;
      dta1,dta2: TDateTime;
      stt: Integer	;
      emi: TnfeEmis;
      codgrp: Integer	;
  end;

  Tsitnfe = (sitAuto,sitCanc,sitDene,sitReje,sitEmProcess,sitPendente,sitTodo);
  TfilterNfe = record
      cfil:Integer;
      lot1,lot2 :integer;
      fil1,fil2 :integer;
      crg1,crg2 :integer;
      ped1,ped2 :integer;
      ntf1,ntf2 :integer;
      dta1,dta2 :Tdatetime;
      sit       :Tsitnfe;
      emi       :TnfeEmis;
      stt       :Integer;
    end;

type  Testnfelot00List=class(TPointerList)
      type Testnfelot00=class(TPointerList)
           type Testnotfis00=class(TPointerList)
                type  Testnotfis01=class(TCObject)
                      private
                          CParent:Testnotfis00;
                          Index:Integer;
                      public
                          ntf01_itmproitm     :Integer;
                          ntf01_itmproqtd     :Extended;
                          ntf01_itmpropco     :Extended;
                          ntf01_itmprottl     :Currency ;
                          ntf01_itmsittri     :Integer  ;
                          ntf01_itmcodfis     :Integer  ;
                          ntf01_itmpericm     :Currency ;
                          ntf01_itmproicm     :Currency ;
                          ntf01_itmcodcfo			:Integer  ;
                          ntf01_itmrbcper     :Currency ;
                          ntf01_itmrbcvlr     :Currency ;
                          ntf01_itmicmsubbas  :Currency ;
                          ntf01_itmicmsubtot  :Currency ;
                          ntf01_itmicmsubper  :Currency ;
                          ntf01_itmperipi     :Currency ;
                          ntf01_itmproipi     :Currency ;
                          ntf01_itmicmszerbs  :Boolean	;

                          // det med
                          ntf01_itmpcopmc    :Currency	;
                          ntf01_pronumlotfab :string;
                          ntf01_prodatlotfab :TDateTime	;
                          ntf01_prodatlotven :TDateTime	;

                          // 15.04.2011 - despesas acessoria por item
                          ntf01_itmvlrdsp    :Currency;

                          // 08.11.2011 - base de calc por item
                          ntf01_itmicmbas: Currency ;

                          // 14.02.2012 - desconto por item
                          ntf01_itmvlrdes: Currency;

                          // 12.05.2012 - frete por item
                          ntf01_itmvlrfre: Currency;

                          //29.05.2013-Valor aproximado total dos tributos por item (NT2013.003)
//                          ntf01_imp_vlrtricon: Currency;
//                          ntf01_imp_alqtricon: Currency;

                          // produto
                          pro00_codigo        :Integer  ;
                          pro00_codbar        :string   ;
                          pro00_descri        :string   ;
                          pro00_unidad        :string   ;
                          pro00_clsfis        :Integer  ;
                          pro00_indfrac       :Boolean  ;
                          pro00_deflotfab			:Boolean	;
                          pro00_codncm        :string ;

                          //05.09.2013 - Tipo Origem da mercadoria CST ICMS. origem da mercadoria
                          opt00_optcod: Integer ;
                      end;

                private
                    CParent:Testnfelot00;
                    Index:Integer;
                private
                    ffinrecdup00List:Tfinrecdup00List;
                    festtipfis01List:Testtipfis01List;
                    fNFe            :TNFe;
                    finfProt        :TinfProt;
//                    fConfigNFe			:TconfigNFe;
                  	function CLoadItems: Boolean;
                    function Get(Index: Integer): Testnotfis01;
                public
                    property Items[Index:Integer]: Testnotfis01 read Get;
                    property NFe    : TNFe      read fNFe     write fNFe;
                    property infProt: TinfProt  read finfProt write finfProt;
                    function CreateNew: Testnotfis01;
                    function IndexOf(ntf01_itmproitm: Integer): Testnotfis01;
                public
                    procedure DoFillXML;
                    procedure DoPrintDANFE(const Destino: Byte;
                                        const Impressora: string;
                                        const Copias: Integer);

                    function GetXml(const ALayout: TLayOut): string;
                    function PrintDANFE(const outDanfe : TOutiputDanfe;
                                        const outDevive: string;
                                        const outCopies: Integer;
                                        var FileName: string;
                                        var retMsg: string): Boolean;

                    function SendMail(out AMsg: string): Boolean;
                    function SaveXmlToFile(const ALayout: TLayOut;
                                           const ALocal: string): Boolean;
                public
                    ntf00_nfelot          :Integer  ;
                    ntf00_nfekey          :string   ;
                    ntf00_nfeser          :Integer  ;
                    ntf00_nfeemi          :TnfeEmis ;
                    ntf00_nfestt          :Integer  ;
                    ntf00_nfemot          :string   ;
                    ntf00_nferetcon       :string   ;
                    ntf00_nfeamb          :TnfeAmb  ;
                    ntf00_nfexml          :string   ;
                    ntf00_nfedigval       :string   ;
                    ntf00_nfesendmail			:Boolean	;
                    ntf00_nfesendmailmsg	:string	;
                    ntf00_nfedhrecbto     :TDateTime;
                    ntf00_nfeverapp				:string		;

                    ntf00_codseq          :Integer;
                    ntf00_codfil          :Integer;
                    ntf00_codtyp          :Integer;
                    ntf00_codntf          :Integer;

                    ntf00_rem_ntf_fis     :Integer;
                    ntf00_rem_cod_ped     :Integer;
                    ntf00_rem_crg_cod     :Integer;
                    ntf00_rem_cod_ven     :Integer;
                    ntf00_rem_cod_cli     :Integer;
                    ntf00_rem_dat_emi     :TDateTime;
                    ntf00_rem_dat_sai     :TDateTime;
                    ntf00_rem_cfopcod     :Integer;
                    ntf00_rem_observa     :string;
                    ntf00_rem_fatobs00    :string;

                    ntf00_imp_base_icm    :Currency;
                    ntf00_imp_vlr_icm     :Currency;
                    ntf00_imp_bas_icm_sub :Currency;
                    ntf00_imp_vlr_icm_sub :Currency;
                    ntf00_imp_vlr_ttl_pro :Currency;
                    ntf00_imp_vlr_frete   :Currency;
                    ntf00_imp_vlr_seguro  :Currency;
                    ntf00_imp_vlr_desco   :Currency;
                    ntf00_imp_vlr_ttl_ipi :Currency;
                    ntf00_imp_out_despe   :Currency;
                    ntf00_imp_vlr_ttl_ntf :Currency;

                    ntf00_trp_cod_trp     :Integer ;
                    ntf00_trp_raz_soc     :string  ;
                    ntf00_trp_cpf_cnp     :string  ;
                    ntf00_trp_fre_tip     :Integer ;
                    ntf00_trp_crr_pla     :string  ;
                    ntf00_trp_crr_uf      :string  ;
                    ntf00_trp_pes_bru     :Currency;
                    ntf00_trp_pes_liq     :Currency;

                    ntf00_trp_endere:string  ;
                    ntf00_trp_cidnom:string  ;
                    ntf00_trp_cid_uf:string  ;

                    //06.11.2012 - copia da NF-e autorizada em um local pre-definido
                    ntf00_nfecopy         :Boolean ;

                    //29.05.2013-Valor aproximado total dos tributos(NT2013.003)
                    ntf00_imp_vlrtricon: Currency;
                    ntf00_imp_alqtricon: Currency;

                    //07.08.2013 - NFC-e
                    ntf00_nfemod: Byte;
                    ntf00_nfeiddest: TnfeIdOpera ;
                    ntf00_nfetpimp: TnfeFormDANFE ;
                    ntf00_nfeindfinal: TnfeIndOpeFinal;
                    ntf00_nfeindpres: TnfeIndPresCons;

                    mov00_codtyp          :Integer;
                    mov00_fatqtdvol       :Integer;

                    // 26.05.2011 - cupom/pdv/coo/ecf/pre-venda
                    mov00_cuppdv:Integer;
                    mov00_cupcod:Integer;
                    mov00_cupcoo:Integer;
                    mov00_cupecf:Integer;
                    mov00_cuppreven:Integer;

                    cfop00_descri         :string;

                    fil00_codigo          :Integer;
                    fil00_cgc             :string;
                    fil00_insest          :string;
                    fil00_descri          :string;
                    fil00_logr            :string;
                    fil00_nlogr           :string;
                    fil00_bairro          :string;
                    fil00_codibge         :Integer;
                    fil00_mun             :string;
                    fil00_uf              :string;
                    fil00_ufcod		  		  :Integer;
                    fil00_cep             :string;
                    fil00_ddd             :string;
                    fil00_fone            :string;
                    fil00_sigla           :string;
                    fil00_codcou          :Integer;

                    // 26.08.2010-envio nfe p/ e-mail
                    fil00_nfesmtphost     :string;
                    fil00_nfesmtpport			:Integer;
                    fil00_nfesmtpuser			:string;
                    fil00_nfesmtppass     :string;
                    fil00_nfesmtpmail			:string;
                    //
                    cli00_codigo          :Integer;
                    cli00_ciccgc          :string;
                    cli00_rzsoci          :string;
                    cli00_fantas          :string;
                    cli00_logr            :string;
                    cli00_nlogr           :string;
                    cli00_bairro          :string;
                    cli00_codcid          :Integer;
                    cli00_codibge         :Integer;
                    cli00_mun             :string;
                    cli00_uf              :string;
                    cli00_cep             :string;
                    cli00_rginsc          :string;
                    cli00_typpes          :TPessoaType;
                    cli00_ddd             :string;
                    cli00_fone            :string;
                    cli00_emaildanfe      :string;
                    cli00_codcou          :Integer;

                    //
                    checked: Boolean;
                    catalog: string ;

                public
                    function CConsSitNFe(out AErr: string): Boolean;
                    function CCancelNFe(const AJust: string; out AErr: string): Boolean;
                    function RegisterXML(xml: string):Boolean;
                    procedure DoRegisterSitNFe(const codstt  :Integer     ;
                                               const motstt  :string      ;
                                               const nprot   :string   ='';
                                               const dhrecbto:TDateTime=0 ;
                                               const digval  :string   ='';
                                               const verapp: string='');
                    procedure DoRegisterInfCancNFe(const can00_versao: string  ;
                                                  const can00_ideamb: TnfeAmb  ;
                                                  const can00_verapp: string   ;
                                                  const can00_codstt: Integer  ;
                                                  const can00_motstt: string   ;
                                                  const can00_codest: Integer  ;
                                                  const can00_chnfe : string   ;
                                                  const can00_dhrec : TDateTime;
                                                  const can00_nprot : string  ;
                                                  const can00_justcanc: string);
                    procedure DoRemove;

                    procedure DoRegisterCopyNFe(const ACopy: Boolean);
                public
                    constructor Create;
                    destructor Destroy; Override;
                end;

           public
              Index:Integer;
              CParent:Testnfelot00List;
              Checked:Boolean;
           public
              lot00_codlot:Integer   ;
              lot00_codusr:Integer   ;
              lot00_datsys:TDateTime ;
              lot00_datret:TDateTime ;
              lot00_status:Testnfelot00Stt;

              lot00_comabm: TnfeAmb ;
              lot00_nfeemi: TnfeEmis;
              lot00_comapp: string  ;
              lot00_comstt: Integer ;
              lot00_commot: string  ;
              lot00_comest: Integer ;
              lot00_retrec: string  ;
              lot00_retdat: Tdatetime;
              lot00_lotcon: Integer ;
              lot00_scrxmlger:string;

              procedure Clear;
              function CLoad(filter: TfilterNfe): Boolean;
              function CLoadXML: Boolean;

              function CreateNew: Testnotfis00;
           private
              function Get(Index: Integer): Testnotfis00;
           protected
              fconfigNFe:TconfigNFe;
              fLoteStr  :String; // WideString;
              procedure RegisterSttLote(const lot00_comabm	: TnfeAmb ;
                                        const lot00_comapp	: string  ;
                                        const lot00_comstt	: Integer ;
                                        const lot00_commot	: string  ;
                                        const lot00_comest	: Integer ;
                                        const lot00_retrec	: string='';
                                        const lot00_retdat	: TDateTime=0);
              procedure RegisterSitNFe( const lot00_comstt: Integer ;
                                        const lot00_commot: string);

              function Assinar(out retMsg: String): Boolean;
              function Validar(out codStt: Integer; out motStt: String): Boolean;
           public
              procedure Delete(Index:Integer);
              procedure KillLOT;

              function SaveXmlToFile: Boolean;

              function ExistCHK: Boolean;

           public
              property Items[Index:Integer]:Testnotfis00 read Get;
           public
              procedure DoGer(out retCod: Integer; out retMsg: string);
              procedure Gerar;
              procedure Imprimir(const printerName: string=''; const printerHost: string ='');

              function Enviar(out retMsg: string):Boolean;
              function ConsultarReci(out retMsg: string):Boolean;
              function CCancel:Boolean;
              function IndexOfByKEY(const ntf00_nfekey:string):Testnfelot00List.Testnfelot00.Testnotfis00;
              function IndexOfByCOD(const ntf00_codntf:Integer):Testnfelot00List.Testnfelot00.Testnotfis00;
              function Remover(out retMsg: string): Boolean ;
           public
              constructor Create;
              destructor  Destroy; override;
           end;

      private
        function Get(Index:Integer):Testnfelot00;
      public
        procedure CLoad(filter: TFilterLot);
        function IndexOf(lot00_codlot:Integer):Testnfelot00;
        function Exist(lot00_codlot:Integer):Boolean;
        function CreateNew:Testnfelot00;
        function ExistCHK: Boolean;
        function ToArrayString(JustCHK:Boolean=True): string;
      public
        property Items[Index:Integer]:Testnfelot00 read Get;
      end;

{$ENDREGION}

implementation

uses StrUtils , DateUtils	,
  NativeXml   ,
	//
  ulib, ucon ,
  //ulog ,
  umetadata,
  ueventonfe00;


{$REGION 'Testnfelot00List'}

{ Testnfelot00List.Testnfelot00 }

function Testnfelot00List.Testnfelot00.Assinar(out retMsg: String): Boolean;
var i: Integer;
var n: Testnfelot00List.Testnfelot00.Testnotfis00;
var x1,x2: string	;
begin
  	fLoteStr :='';
    for i :=0 to Self.Count -1 do
    begin
        n     :=Self.Items[i];
        if((n.ntf00_nfestt =TNFe.COD_DON_ENVIO)and(n.ntf00_nfeemi in[emisCon_FS,emisCon_FSDA]))then
        begin
            Result :=True ;
        end
        else begin
            Result:=n.NFe.Assinar(fconfigNFe.GetCertificado, retMsg);
        end;

        if Result then
        begin
            fLoteStr :=fLoteStr + n.NFe.XML;
        end
        else begin
            Break;
        end;
    end;
end;

function Testnfelot00List.Testnfelot00.CCancel: Boolean;
begin
     Result:=False;
end;

procedure Testnfelot00List.Testnfelot00.Clear;
begin
     lot00_codlot:=00   ;
     lot00_codusr:=00   ;
     lot00_datsys:=00   ;
     lot00_datret:=00   ;
     lot00_status:=enlNSend ;
end;

function Testnfelot00List.Testnfelot00.CLoad(filter: TfilterNfe): Boolean;
var q:TQueryDBZ;

var n0:Testnfelot00List.Testnfelot00.Testnotfis00;

var fntf00_nfelot           :TField;
var fntf00_nfekey           :TField;
var fntf00_nfeemi           :TField;
var fntf00_nfeser           :TField;
var fntf00_nfestt           :TField;
var fntf00_nfemot           :TField;
var fntf00_nferetcon        :TField;
var fntf00_nfedigval        :TField;
var fntf00_nfedhrecbto      :TField;
var fntf00_nfeverapp        :TField;
var fntf00_nfeamb           :TField;
var fntf00_nfexml           :TField;
var fntf00_nfesendmail      :TField;
var fntf00_nfesendmailmsg   :TField;
var fntf00_nfecopy:TField;

var fntf00_codseq           :TField;
var fntf00_codfil           :TField;
var fntf00_codtyp           :TField;
var fntf00_codntf           :TField;

var fntf00_rem_ntf_fis      :TField;
var fntf00_rem_cod_ped      :TField;
var fntf00_rem_crg_cod      :TField;
var fntf00_rem_cod_ven      :TField;
var fntf00_rem_cod_cli      :TField;
var fntf00_rem_dat_emi      :TField;
var fntf00_rem_dat_sai      :TField;
var fntf00_rem_cfopcod      :TField;
var fntf00_rem_observa      :TField;
var fntf00_rem_fatobs00     :TField;

var fntf00_imp_base_icm    :TField;
var fntf00_imp_vlr_icm     :TField;
var fntf00_imp_bas_icm_sub :TField;
var fntf00_imp_vlr_icm_sub :TField;
var fntf00_imp_vlr_ttl_pro :TField;
var fntf00_imp_vlr_frete   :TField;
var fntf00_imp_vlr_seguro  :TField;
var fntf00_imp_vlr_desco   :TField;
var fntf00_imp_vlr_ttl_ipi :TField;
var fntf00_imp_out_despe   :TField;
var fntf00_imp_vlr_ttl_ntf :TField;

var fntf00_imp_vlrtricon: TField;
var fntf00_imp_alqtricon: TField;

var fntf00_trp_cod_trp      :TField;
var fntf00_trp_raz_soc      :TField;
var fntf00_trp_cpf_cnp      :TField;
var fntf00_trp_fre_tip      :TField;
var fntf00_trp_crr_pla      :TField;
var fntf00_trp_crr_uf       :TField;
var fntf00_trp_pes_liq      :TField;
var fntf00_trp_pes_bru      :TField;

//07.08.2013 - NFC-e
var fntf00_nfemod: TField;
var fntf00_nfeiddest: TField;
var fntf00_nfetpimp: TField;
var fntf00_nfeindfinal: TField;
var fntf00_nfeindpres: TField;

var fmov00_codtyp           :TField;
var fmov00_fatqtdvol        :TField;

// 26.05.2011 - cupom/pdv
var fmov00_cuppdv:TField;
var fmov00_cupcod:TField;
var fmov00_cupcoo:TField;
var fmov00_cupecf:TField;
var fmov00_cuppreven:TField;

var fcfop00_descri          :TField;

var ffil00_codigo           :TField;
var ffil00_cgc              :TField;
var ffil00_insest           :TField;
var ffil00_descri           :TField;
var ffil00_logr             :TField;
var ffil00_nlogr            :TField;
var ffil00_bairro           :TField;
var ffil00_codibge          :TField;
var ffil00_mun              :TField;
var ffil00_uf               :TField;
var ffil00_ufcod		  		  :TField;
var ffil00_cep              :TField;
var ffil00_ddd              :TField;
var ffil00_fone             :TField;
var ffil00_sigla            :TField;
var ffil00_nfesmtphost     	:TField;
var ffil00_nfesmtpport			:TField;
var ffil00_nfesmtpuser			:TField;
var ffil00_nfesmtppass     	:TField;
var ffil00_nfesmtpmail			:TField;

var fcli00_codigo           :TField;
var fcli00_ciccgc           :TField;
var fcli00_rzsoci           :TField;
var fcli00_fantas           :TField;
var fcli00_logr             :TField;
var fcli00_nlogr            :TField;
var fcli00_bairro           :TField;
var fcli00_codcid           :TField;
var fcli00_codibge          :TField;
var fcli00_mun              :TField;
var fcli00_uf               :TField;
var fcli00_cep              :TField;
var fcli00_rginsc           :TField;
var fcli00_typpes           :TField;
var fcli00_ddd              :TField;
var fcli00_fone             :TField;
var fcli00_emaildanfe       :TField;

var fntf00_trp_endere:TField;
var fntf00_trp_cidnom:TField;
var fntf00_trp_cid_uf:TField;

var ffil00_codcou    :TField;
var fcli00_codcou    :TField;

var exits_cli00_codbai:Boolean	;
var catalog: string ;

begin
    //
    inherited Clear(True);
    //

    exits_cli00_codbai :=TMetaData.ObjExists('cadcli00', 'cli00_codbai', catalog) ;

    //
    q :=NewQueryDBZ(CDataBase);
    q.sql.Add('select                                                                ');
    q.sql.Add('      ntf00_nfelot                          ,                         ');
    q.sql.Add('      ntf00_nfekey                          ,                         ');
    q.sql.Add('      ntf00_nfeemi                          ,                         ');
    q.sql.Add('      ntf00_nfeser                          ,                         ');
    q.sql.Add('      ntf00_nfestt                          ,                         ');
    q.sql.Add('      ntf00_nfemot                          ,                         ');
    q.sql.Add('      ntf00_nferetcon                       ,                         ');
    q.sql.Add('      ntf00_nfedigval                       ,                         ');
    q.sql.Add('      ntf00_nfedhrecbto                     ,                         ');
    q.sql.Add('      ntf00_nfeamb                          ,                         ');
    q.sql.Add('      ntf00_nfexml                          ,                         ');
    q.sql.Add('      ntf00_nfesendmail                     ,                         ');
    q.sql.Add('      ntf00_nfesendmailmsg                  ,                         ');

    q.sql.Add('      ntf00_codseq                          ,                         ');
    q.sql.Add('      ntf00_codfil                          ,                         ');
    q.sql.Add('      ntf00_codtyp                          ,                         ');
    q.sql.Add('      ntf00_codntf                          ,                         ');

    q.sql.Add('      ntf00_rem_ntf_fis                     ,                         ');
    q.sql.Add('      ntf00_rem_cod_ped                     ,                         ');
    q.sql.Add('      ntf00_rem_crg_cod                     ,                         ');
    q.sql.Add('      ntf00_rem_cod_ven                     ,                         ');
    q.sql.Add('      ntf00_rem_cod_cli                     ,                         ');
    q.sql.Add('      ntf00_rem_dat_emi                     ,                         ');
    q.sql.Add('      ntf00_rem_dat_sai                     ,                         ');
    q.sql.Add('      ntf00_rem_cfopcod                     ,                         ');
    q.sql.Add('      ntf00_rem_observa                     ,                         ');
    q.sql.Add('      ntf00_rem_fatobs00                    ,                         ');

    q.sql.Add('      ntf00_imp_base_icm                    ,                         ');
    q.sql.Add('      ntf00_imp_vlr_icm                     ,                         ');
    q.sql.Add('      ntf00_imp_bas_icm_sub                 ,                         ');
    q.sql.Add('      ntf00_imp_vlr_icm_sub                 ,                         ');
    q.sql.Add('      ntf00_imp_vlr_ttl_pro                 ,                         ');
    q.sql.Add('      ntf00_imp_vlr_frete                   ,                         ');
    q.sql.Add('      ntf00_imp_vlr_seguro                  ,                         ');
    q.sql.Add('      ntf00_imp_vlr_desco                   ,                         ');
    q.sql.Add('      ntf00_imp_vlr_ttl_ipi                 ,                         ');
    q.sql.Add('      ntf00_imp_out_despe                   ,                         ');
    q.sql.Add('      ntf00_imp_vlr_ttl_ntf                 ,                         ');

    //29.05.2013-Valor aproximado dos tributos (NT2013.003)
    if TMetaData.ObjExists('estnotfis00','ntf00_imp_vlrtricon') then
    begin
    		q.sql.Add('   ntf00_imp_vlrtricon ,                                  ');
        q.sql.Add('   ntf00_imp_alqtricon ,                                  ');
    end
    else
    begin
    		q.sql.Add('   0 as ntf00_imp_vlrtricon ,                             ');
        q.sql.Add('   0 as ntf00_imp_alqtricon ,                             ');
    end;

    Q.sql.Add('      ntf00_trp_cod_trp                     ,                         ');
    Q.sql.Add('      ntf00_trp_raz_soc                     ,                         ');
    Q.sql.Add('      ntf00_trp_cpf_cnp                     ,                         ');
    Q.sql.Add('      ntf00_trp_fre_tip                     ,                         ');
    Q.sql.Add('      ntf00_trp_crr_pla                     ,                         ');
    Q.sql.Add('      ntf00_trp_crr_uf                      ,                         ');
    Q.sql.Add('      ntf00_trp_pes_liq                     ,                         ');
    Q.sql.Add('      ntf00_trp_pes_bru                     ,                         ');
    Q.sql.Add('      ntf00_trp_endere  ,                                             ');
    Q.sql.Add('      ntf00_trp_cidnom  ,                                             ');
    Q.sql.Add('      ntf00_trp_cid_uf  ,                                             ');

    // 15.07.2010 - ntf00_rem_cfop
    if TMetaData.ObjExists('estnotfis00','ntf00_rem_cfop') then
    begin
    		q.sql.Add('      ntf00_rem_cfop as cfop00_descri   ,                         ');
    end
    else begin
    		q.sql.Add('      cfop00_descri     								 ,                         ');
    end;

    // 06.11.2012 - copia da NF-e autorizada em um local pre-definido
    if TMetaData.ObjExists('estnotfis00','ntf00_nfecopy') then
    begin
    		q.sql.Add('      isnull(ntf00_nfecopy,0) as ntf00_nfecopy,                   ');
    end
    else begin
    		q.sql.Add('      0 as ntf00_nfecopy,                                         ');
    end;

    q.sql.Add('      mov00_codtyp                          ,                         ');
    q.sql.Add('      mov00_fatqtdvol                  		 ,                         ');

    // 30.05.2011 - nf-e com ecf (embale)
    if catalog = Tcatalog_table.catalog_em then
    begin
        q.sql.Add('      isnull(mov00_cuppdv,0) as mov00_cuppdv,	                   ');
        q.sql.Add('      isnull(mov00_cupcod,0) as mov00_cupcod,                     ');
        q.sql.Add('      isnull(mov00_cupcoo,0) as mov00_cupcoo,                     ');
        q.sql.Add('      isnull(mov00_cupecf,0) as mov00_cupecf,                     ');
        q.sql.Add('      isnull(mov00_cuppreven,0) as mov00_cuppreven,               ');
    end
//    if TMetaData.ObjExists('estpedmov00', 'mov00_cuppdv') then
//    begin
//        q.sql.Add('      isnull(mov00_cuppdv,0) as mov00_cuppdv,	                   ');
//        q.sql.Add('      isnull(mov00_cupcod,0) as mov00_cupcod,                     ');
//        q.sql.Add('      isnull(mov00_cupcoo,0) as mov00_cupcoo,                     ');
//        q.sql.Add('      isnull(mov00_cupecf,0) as mov00_cupecf,                     ');
//        q.sql.Add('      isnull(mov00_cuppreven,0) as mov00_cuppreven,               ');
//    end
    else begin
        q.sql.Add('      0 as mov00_cuppdv,	                                        ');
        q.sql.Add('      0 as mov00_cupcod,                                         ');
        q.sql.Add('      0 as mov00_cupcoo,                                         ');
        q.sql.Add('      0 as mov00_cupecf,                                         ');
        q.sql.Add('      0 as mov00_cuppreven,                                      ');
    end;

    // 07.08.2013 - NFC-e
    if TMetaData.ObjExists('estnotfis00', 'ntf00_nfemod', catalog) then
    begin
      q.sql.Add('      isnull(ntf00_nfemod,55)    as ntf00_nfemod  ,                ');
      q.sql.Add('      isnull(ntf00_nfeiddest,1)  as ntf00_nfeiddest ,              ');
      q.sql.Add('      isnull(ntf00_nfetpimp,1)   as ntf00_nfetpimp   ,             ');
      q.sql.Add('      isnull(ntf00_nfeindfinal,1)  as ntf00_nfeindfinal   ,            ');
      q.sql.Add('      isnull(ntf00_nfeindpres,1) as ntf00_nfeindpres ,             ');
    end
    else begin
      q.sql.Add('      55 as ntf00_nfemod     ,                                      ');
      q.sql.Add('      1  as ntf00_nfeiddest  ,                                      ');
      q.sql.Add('      1  as ntf00_nfetpimp   ,                                      ');
      q.sql.Add('      1  as ntf00_nfeindfinal  ,                                      ');
      q.sql.Add('      1  as ntf00_nfeindpres ,                                      ');
    end;

    q.sql.Add('      fil00_codigo                          ,                         ');
    q.sql.Add('      fil00_cgc                             ,                         ');
    q.sql.Add('      fil00_insest                          ,                         ');
    q.sql.Add('      fil00_descri                          ,                         ');
    q.sql.Add('      fil00_ende as fil00_logr              ,                         ');
    q.sql.Add('      right(fil00_cep,3) as fil00_nlogr     ,                         ');
    q.sql.Add('      fil00_bairro                          ,                         ');
    q.sql.Add('      m1.cid00_ibgecod as fil00_codibge     ,                         ');
    q.sql.Add('      m1.cid00_descri as fil00_mun          ,                         ');
    q.sql.Add('      e1.est00_ibgecod as fil00_ufcod	 		 ,                         ');
    q.sql.Add('      e1.est00_sigla as fil00_uf            ,                         ');
    q.sql.Add('      fil00_cep                             ,                         ');
    q.sql.Add('      fil00_ddd                             ,                         ');
    q.sql.Add('      fil00_fone                            ,                         ');
    q.sql.Add('      fil00_sigla                           ,                         ');
    q.sql.Add('      fil00_nfesmtphost                     ,                         ');
    q.sql.Add('      fil00_nfesmtpport                     ,                         ');
    q.sql.Add('      fil00_nfesmtpuser                     ,                         ');
    q.sql.Add('      fil00_nfesmtppass                     ,                         ');
    q.sql.Add('      fil00_nfesmtpmail                     ,                         ');
    if TMetaData.ObjExists('cadfil00', 'fil00_codcou') then
    begin
      q.sql.Add('      fil00_codcou                     ,                       ');
    end
    else begin
      q.sql.Add('      31 as fil00_codcou             ,                         ');
    end;
    q.sql.Add('      cli00_codigo                          ,                         ');
    q.sql.Add('      cli00_ciccgc                          ,                         ');
    q.sql.Add('      cli00_rzsoci                          ,                         ');
    q.sql.Add('      cli00_fantas                          ,                         ');
    q.sql.Add('      cli00_endere as cli00_logr            ,                         ');
    q.sql.Add('      cli00_log as cli00_nlogr              ,                         ');

    if exits_cli00_codbai then
    begin
        q.sql.Add('  b2.bai00_descri as cli00_bairro       ,                         ');
    end
    else begin
        q.sql.Add('  cli00_bairro                          ,                         ');
    end;

    q.sql.Add('      cli00_codcid                          ,                         ');
    q.sql.Add('      m2.cid00_ibgecod as cli00_codibge     ,                         ');
    q.sql.Add('      m2.cid00_descri as cli00_mun          ,                         ');
    q.sql.Add('      e2.est00_sigla as cli00_uf            ,                         ');
    if TMetaData.ObjExists('cadcli00', 'cli00_codcou') then
    begin
      q.sql.Add('      cli00_codcou                     ,                       ');
    end
    else begin
      q.sql.Add('      31 as cli00_codcou             ,                         ');
    end;
    q.sql.Add('      cli00_cep                             ,                         ');
    q.sql.Add('      cli00_rginsc                          ,                         ');
    q.sql.Add('      cli00_typpes                          ,                         ');
    q.sql.Add('      cli00_ddd1                            ,                         ');
    q.sql.Add('      cli00_fone1                           ,                         ');
    q.sql.Add('      cli00_emaildanfe                                                ');
    q.sql.Add('from cadfil00 (nolock)                                                ');
//    q.sql.Add('from estnotfis00 (nolock)                                             ');
    q.sql.Add('inner join estnotfis00 (nolock) on fil00_codigo = ntf00_codfil        ');
    q.sql.Add('inner join estpedmov00 (nolock) on mov00_codfil = ntf00_codfil        ');
		q.sql.Add('                               and mov00_codmov = ntf00_rem_cod_ped   ');
    q.sql.Add('left  join estcfop00   (nolock) on cfop00_codigo   = ntf00_rem_cfopcod');
//    q.sql.Add('left  join cadfil00    (nolock) on fil00_codigo    = ntf00_codfil     ');
    q.sql.Add('left  join cadcid00 m1	(nolock) on m1.cid00_codigo = fil00_codcid     ');
    q.sql.Add('left  join cadest00 e1 (nolock) on e1.est00_codigo = fil00_codest     ');
    q.sql.Add('left  join cadcli00    (nolock) on cli00_codigo    = ntf00_rem_cod_cli');
    if exits_cli00_codbai then
    begin
        q.sql.Add('left  join cadbai00 b2 (nolock) on b2.bai00_codigo = cli00_codbai ');
    end;
    q.sql.Add('left  join cadcid00 m2 (nolock) on m2.cid00_codigo = cli00_codcid     ');
    q.sql.Add('left  join cadest00 e2 (nolock) on e2.est00_codigo = cli00_codest     ');

    if filter.lot1>0 then
    begin
      	q.sql.Add('where ntf00_nfelot	between %d and %d                              ',[filter.lot1,filter.lot2]);
        if catalog=Tcatalog_table.catalog_em then
        begin
            q.sql.Add('order by cli00_rzsoci                             ');
        end
        else begin
            q.sql.Add('order by ntf00_nfelot	,                                              ');
            q.sql.Add('         ntf00_codntf	                                               ');
        end;
    end
    else begin
        if filter.ped1>0 then
        begin
            q.sql.Add('where  fil00_codigo=%d                                   ',[filter.fil1]);
            q.sql.Add('and    ntf00_rem_cod_ped  between %d and %d            	',[filter.ped1,filter.ped2]);
        end
        else begin
          	q.sql.Add('where  fil00_codigo=%d                                   ',[filter.fil1]);
            if filter.crg1>0 then
            begin
                q.SQL.Add('and 	ntf00_rem_crg_cod  between %d and %d          ',[filter.crg1,filter.crg2]);
            end
            else if filter.ntf1>0	then
            begin
                q.sql.Add('and  ntf00_rem_ntf_fis  between %d and %d             	',[filter.ntf1,filter.ntf2]);
            end;

            //-- não emitida
            if filter.emi=emisNone then
            begin
                q.SQL.Add('and 	ntf00_nfelot = 0                              ');
            end
            else if filter.emi in[emisNomal,emisCon_SCAN] then
            begin
                q.SQL.Add('and	ntf00_nfeemi = %d',[Ord(filter.emi)]);

                case filter.sit of
                    sitAuto:q.SQL.Add('and 	ntf00_nfestt = 100              ');
                    sitCanc:q.SQL.Add('and 	ntf00_nfestt = 101              ');
                    sitDene:q.SQL.Add('and 	ntf00_nfestt between 301 and 302');
                    sitReje:
                    begin
                            q.SQL.Add('and 	((ntf00_nfestt between 201 and 299) ');
                            q.SQL.Add('or 	 (ntf00_nfestt between 401 and 478) ');
                            q.SQL.Add('or 	 (ntf00_nfestt between 501 and 599))');
                    end;
                    sitPendente:q.SQL.Add('and 	ntf00_nfestt = 99               ');
                end;
            end
            else begin
                if filter.emi<>emisNone then
                begin
                		q.SQL.Add('and	ntf00_nfeemi = %d',[Ord(filter.emi)]);
                end;
            end;
            q.sql.Add('and  ntf00_rem_dat_emi  between %s and %s          		',[Q.SQLFun.SDatSQL(filter.dta1),Q.SQLFun.SDatSQL(filter.dta2,True)]);


            //05.09.2012 ordem na embale (mesma do pedido)
            if catalog=Tcatalog_table.catalog_em then
            begin
                q.sql.Add('order by cli00_rzsoci                             ');
            end
//            if filter.crg1>0 then
//            begin
//                q.sql.Add('order by ntf00_codfil	,     										 ');
//                q.sql.Add('      		ntf00_rem_crg_cod    										 ');
//            end
            else begin
                q.sql.Add('order by ntf00_codfil	,     										 ');
                q.sql.Add('      		ntf00_codtyp	,     										 ');
                q.sql.Add('      		ntf00_codntf	      										 ');
            end;
        end;
    end;

    q.sql.SaveToFile('0.sql');
    q.Open;

    Result :=not q.IsEmpty;

    fntf00_nfelot           :=q.Field('ntf00_nfelot         ');
    fntf00_nfekey           :=q.Field('ntf00_nfekey         ');
    fntf00_nfeemi           :=q.Field('ntf00_nfeemi         ');
    fntf00_nfeser           :=q.Field('ntf00_nfeser         ');
    fntf00_nferetcon        :=q.Field('ntf00_nferetcon      ');
    fntf00_nfestt           :=q.Field('ntf00_nfestt         ');
    fntf00_nfemot           :=q.Field('ntf00_nfemot         ');
    fntf00_nfedigval        :=q.Field('ntf00_nfedigval      ');
    fntf00_nfedhrecbto      :=q.Field('ntf00_nfedhrecbto    ');
    fntf00_nfeamb           :=q.Field('ntf00_nfeamb         ');
    fntf00_nfexml           :=q.Field('ntf00_nfexml         ');
    fntf00_nfesendmail      :=q.Field('ntf00_nfesendmail    ');
    fntf00_nfesendmailmsg   :=q.Field('ntf00_nfesendmailmsg ');
    fntf00_nfecopy          :=q.Field('ntf00_nfecopy        ');

    fntf00_codseq           :=q.Field('ntf00_codseq         ');
    fntf00_codfil           :=q.Field('ntf00_codfil         ');
    fntf00_codtyp           :=q.Field('ntf00_codtyp         ');
    fntf00_codntf           :=q.Field('ntf00_codntf         ');

    fntf00_rem_ntf_fis      :=q.Field('ntf00_rem_ntf_fis    ');
    fntf00_rem_cod_ped      :=q.Field('ntf00_rem_cod_ped    ');
    fntf00_rem_crg_cod      :=q.Field('ntf00_rem_crg_cod    ');
    fntf00_rem_cod_ven      :=q.Field('ntf00_rem_cod_ven    ');
    fntf00_rem_cod_cli      :=q.Field('ntf00_rem_cod_cli    ');
    fntf00_rem_dat_emi      :=q.Field('ntf00_rem_dat_emi    ');
    fntf00_rem_dat_sai      :=q.Field('ntf00_rem_dat_sai    ');
    fntf00_rem_cfopcod      :=q.Field('ntf00_rem_cfopcod    ');
    fntf00_rem_observa      :=q.Field('ntf00_rem_observa    ');
    fntf00_rem_fatobs00     :=q.Field('ntf00_rem_fatobs00   ');

    fntf00_imp_base_icm     :=q.Field('ntf00_imp_base_icm   ');
    fntf00_imp_vlr_icm      :=q.Field('ntf00_imp_vlr_icm    ');
    fntf00_imp_bas_icm_sub  :=q.Field('ntf00_imp_bas_icm_sub');
    fntf00_imp_vlr_icm_sub  :=q.Field('ntf00_imp_vlr_icm_sub');
    fntf00_imp_vlr_ttl_pro  :=q.Field('ntf00_imp_vlr_ttl_pro');
    fntf00_imp_vlr_frete    :=q.Field('ntf00_imp_vlr_frete  ');
    fntf00_imp_vlr_seguro   :=q.Field('ntf00_imp_vlr_seguro ');
    fntf00_imp_vlr_desco    :=q.Field('ntf00_imp_vlr_desco  ');
    fntf00_imp_vlr_ttl_ipi  :=q.Field('ntf00_imp_vlr_ttl_ipi');
    fntf00_imp_out_despe    :=q.Field('ntf00_imp_out_despe  ');
    fntf00_imp_vlr_ttl_ntf  :=q.Field('ntf00_imp_vlr_ttl_ntf');

    fntf00_imp_vlrtricon    :=q.Field('ntf00_imp_vlrtricon');
    fntf00_imp_alqtricon    :=q.Field('ntf00_imp_alqtricon');

    fntf00_trp_cod_trp      :=q.Field('ntf00_trp_cod_trp    ');
    fntf00_trp_raz_soc      :=q.Field('ntf00_trp_raz_soc    ');
    fntf00_trp_cpf_cnp      :=q.Field('ntf00_trp_cpf_cnp    ');
    fntf00_trp_fre_tip      :=q.Field('ntf00_trp_fre_tip    ');
    fntf00_trp_crr_pla      :=q.Field('ntf00_trp_crr_pla    ');
    fntf00_trp_crr_uf       :=q.Field('ntf00_trp_crr_uf     ');
    fntf00_trp_pes_liq      :=q.Field('ntf00_trp_pes_liq    ');
    fntf00_trp_pes_bru      :=q.Field('ntf00_trp_pes_bru    ');
    fntf00_trp_endere      :=q.Field('ntf00_trp_endere    ');
    fntf00_trp_cidnom      :=q.Field('ntf00_trp_cidnom    ');
    fntf00_trp_cid_uf      :=q.Field('ntf00_trp_cid_uf    ');

    fntf00_nfemod     :=q.Field('ntf00_nfemod        ');
    fntf00_nfeiddest  :=q.Field('ntf00_nfeiddest     ');
    fntf00_nfetpimp   :=q.Field('ntf00_nfetpimp      ');
    fntf00_nfeindfinal  :=q.Field('ntf00_nfeindfinal     ');
    fntf00_nfeindpres :=q.Field('ntf00_nfeindpres    ');

    fmov00_codtyp           :=q.Field('mov00_codtyp         ');
    fmov00_fatqtdvol        :=q.Field('mov00_fatqtdvol      ');
    fmov00_cuppdv        		:=q.Field('mov00_cuppdv      		');
    fmov00_cupcod        		:=q.Field('mov00_cupcod      		');
    fmov00_cupcoo        		:=q.Field('mov00_cupcoo      		');
    fmov00_cupecf        		:=q.Field('mov00_cupecf      		');
    fmov00_cuppreven        :=q.Field('mov00_cuppreven   		');

    fcfop00_descri          :=q.Field('cfop00_descri        ');

    ffil00_codigo           :=q.Field('fil00_codigo         ');
    ffil00_cgc              :=q.Field('fil00_cgc            ');
    ffil00_insest           :=q.Field('fil00_insest         ');
    ffil00_descri           :=q.Field('fil00_descri         ');
    ffil00_logr             :=q.Field('fil00_logr           ');
    ffil00_nlogr            :=q.Field('fil00_nlogr          ');
    ffil00_bairro           :=q.Field('fil00_bairro         ');
    ffil00_codibge          :=q.Field('fil00_codibge        ');
    ffil00_mun              :=q.Field('fil00_mun            ');
    ffil00_uf               :=q.Field('fil00_uf             ');
    ffil00_ufcod		  		  :=q.Field('fil00_ufcod          ');
    ffil00_cep              :=q.Field('fil00_cep            ');
    ffil00_ddd              :=q.Field('fil00_ddd            ');
    ffil00_fone             :=q.Field('fil00_fone           ');
    ffil00_sigla            :=q.Field('fil00_sigla          ');
    ffil00_nfesmtphost      :=q.Field('fil00_nfesmtphost    ');
    ffil00_nfesmtpport      :=q.Field('fil00_nfesmtpport    ');
    ffil00_nfesmtpuser      :=q.Field('fil00_nfesmtpuser    ');
    ffil00_nfesmtppass      :=q.Field('fil00_nfesmtppass    ');
    ffil00_nfesmtpmail      :=q.Field('fil00_nfesmtpmail    ');
    ffil00_codcou      :=q.Field('fil00_codcou    ');

    fcli00_codigo           :=q.Field('cli00_codigo         ');
    fcli00_ciccgc           :=q.Field('cli00_ciccgc         ');
    fcli00_rzsoci           :=q.Field('cli00_rzsoci         ');
    fcli00_fantas           :=q.Field('cli00_fantas         ');
    fcli00_logr             :=q.Field('cli00_logr           ');
    fcli00_nlogr            :=q.Field('cli00_nlogr          ');
    fcli00_bairro           :=q.Field('cli00_bairro         ');
    fcli00_codcid           :=q.Field('cli00_codcid         ');
    fcli00_codibge          :=q.Field('cli00_codibge        ');
    fcli00_mun              :=q.Field('cli00_mun            ');
    fcli00_uf               :=q.Field('cli00_uf             ');
    fcli00_cep              :=q.Field('cli00_cep            ');
    fcli00_rginsc           :=q.Field('cli00_rginsc         ');
    fcli00_typpes           :=q.Field('cli00_typpes         ');
    fcli00_ddd              :=q.Field('cli00_ddd1           ');
    fcli00_fone             :=q.Field('cli00_fone1          ');
    fcli00_emaildanfe       :=q.Field('cli00_emaildanfe			');
    fcli00_codcou       :=q.Field('cli00_codcou');

    //
    //errCod:=Tnfecoderr00List.Create;
    //
    while not q.Eof do
    begin

//        n0  :=Self.IndexOfByKEY(fntf00_nfekey.AsString);
        n0  :=Self.IndexOfByCOD(fntf00_codntf.AsInteger);
        if n0 = nil then
        begin
            n0                         :=Self.CreateNew;
            n0.ntf00_nfelot            :=fntf00_nfelot.AsInteger;
            n0.ntf00_nfekey            :=fntf00_nfekey.AsString;
            n0.ntf00_nfeemi            :=TnfeEmis(fntf00_nfeemi.AsInteger);
            if Trim(fntf00_nfeser.AsString)<>'' then
            		n0.ntf00_nfeser            :=fntf00_nfeser.AsInteger
            else
              	n0.ntf00_nfeser            :=000;
            n0.ntf00_nfestt            :=fntf00_nfestt.AsInteger;
            n0.ntf00_nfemot            :=fntf00_nfemot.AsString;
//            if Trim(n0.ntf00_nfemot)='' then
//            begin
//              n0.ntf00_nfemot          :=errCod.IndexOfByCod(n0.ntf00_nfestt);
//            end;
            n0.ntf00_nferetcon         :=fntf00_nferetcon.AsString;
            n0.ntf00_nfedigval         :=fntf00_nfedigval.AsString;
            n0.ntf00_nfedhrecbto       :=fntf00_nfedhrecbto.AsDateTime;
            n0.ntf00_nfeamb            :=TnfeAmb(fntf00_nfeamb.AsInteger);
            n0.ntf00_nfexml            :=fntf00_nfexml.AsString;
            n0.ntf00_nfesendmail       :=fntf00_nfesendmail.AsBoolean;
            n0.ntf00_nfesendmailmsg    :=fntf00_nfesendmailmsg.AsString;
            n0.ntf00_nfecopy           :=fntf00_nfecopy.AsBoolean;

            n0.ntf00_codseq            :=fntf00_codseq.AsInteger;
            n0.ntf00_codfil            :=fntf00_codfil.AsInteger;
            n0.ntf00_codtyp            :=fntf00_codtyp.AsInteger;
            n0.ntf00_codntf            :=fntf00_codntf.AsInteger;

            n0.ntf00_rem_ntf_fis       :=fntf00_rem_ntf_fis.AsInteger;
            n0.ntf00_rem_crg_cod       :=fntf00_rem_crg_cod.AsInteger;
            n0.ntf00_rem_cod_ped       :=fntf00_rem_cod_ped.AsInteger;
            n0.ntf00_rem_cod_ven       :=fntf00_rem_cod_ven.AsInteger;
            n0.ntf00_rem_cod_cli       :=fntf00_rem_cod_cli.AsInteger;
            n0.ntf00_rem_dat_emi       :=fntf00_rem_dat_emi.AsDateTime;
            n0.ntf00_rem_dat_sai       :=fntf00_rem_dat_sai.AsDateTime;
            n0.ntf00_rem_cfopcod       :=fntf00_rem_cfopcod.AsInteger;
            n0.ntf00_rem_observa       :=fntf00_rem_observa.AsString;
            n0.ntf00_rem_fatobs00      :=fntf00_rem_fatobs00.AsString;

            n0.ntf00_imp_base_icm      :=fntf00_imp_base_icm.AsCurrency;
            n0.ntf00_imp_vlr_icm       :=fntf00_imp_vlr_icm.AsCurrency;
            n0.ntf00_imp_bas_icm_sub   :=fntf00_imp_bas_icm_sub.AsCurrency;
            n0.ntf00_imp_vlr_icm_sub   :=fntf00_imp_vlr_icm_sub.AsCurrency;
            n0.ntf00_imp_vlr_ttl_pro   :=fntf00_imp_vlr_ttl_pro.AsCurrency;
            n0.ntf00_imp_vlr_frete     :=fntf00_imp_vlr_frete.AsCurrency;
            n0.ntf00_imp_vlr_seguro    :=fntf00_imp_vlr_seguro.AsCurrency;
            n0.ntf00_imp_vlr_desco     :=fntf00_imp_vlr_desco.AsCurrency;
            n0.ntf00_imp_vlr_ttl_ipi   :=fntf00_imp_vlr_ttl_ipi.AsCurrency;
            n0.ntf00_imp_out_despe     :=fntf00_imp_out_despe.AsCurrency;
            n0.ntf00_imp_vlr_ttl_ntf   :=fntf00_imp_vlr_ttl_ntf.AsCurrency;

            n0.ntf00_imp_vlrtricon     :=fntf00_imp_vlrtricon.AsCurrency;
            n0.ntf00_imp_alqtricon     :=fntf00_imp_alqtricon.AsCurrency;

            n0.ntf00_trp_fre_tip       :=fntf00_trp_fre_tip.AsInteger;
            n0.ntf00_trp_cod_trp       :=fntf00_trp_cod_trp.AsInteger;
            n0.ntf00_trp_raz_soc       :=fntf00_trp_raz_soc.AsString;
            n0.ntf00_trp_cpf_cnp       :=GetNumbers(fntf00_trp_cpf_cnp.AsString);
            n0.ntf00_trp_fre_tip       :=fntf00_trp_fre_tip.AsInteger;
            n0.ntf00_trp_crr_pla       :=fntf00_trp_crr_pla.AsString;
            n0.ntf00_trp_crr_uf        :=fntf00_trp_crr_uf.AsString;
            n0.ntf00_trp_pes_bru       :=fntf00_trp_pes_bru.AsCurrency;
            n0.ntf00_trp_pes_liq       :=fntf00_trp_pes_liq.AsCurrency;
            n0.ntf00_trp_endere       :=fntf00_trp_endere.AsString;
            n0.ntf00_trp_cidnom       :=fntf00_trp_cidnom.AsString;
            n0.ntf00_trp_cid_uf       :=fntf00_trp_cid_uf.AsString;

            n0.ntf00_nfemod         :=fntf00_nfemod.AsInteger;
            n0.ntf00_nfeiddest      :=TnfeIdOpera(fntf00_nfeiddest.AsInteger);
            n0.ntf00_nfetpimp       :=TnfeFormDANFE(fntf00_nfetpimp.AsInteger);
            n0.ntf00_nfeindfinal    :=TnfeIndOpeFinal(fntf00_nfeindfinal.AsInteger);
            n0.ntf00_nfeindpres     :=TnfeIndPresCons(fntf00_nfeindpres.AsInteger);

            n0.mov00_codtyp           :=fmov00_codtyp.AsInteger;
            n0.mov00_fatqtdvol        :=fmov00_fatqtdvol.AsInteger;
            n0.mov00_cuppdv        		:=fmov00_cuppdv.AsInteger;
            n0.mov00_cupcod        		:=fmov00_cupcod.AsInteger;
            n0.mov00_cupcoo        		:=fmov00_cupcoo.AsInteger;
            n0.mov00_cupecf        		:=fmov00_cupecf.AsInteger;
            n0.mov00_cuppreven     		:=fmov00_cuppreven.AsInteger;

            n0.cfop00_descri          :=fcfop00_descri.asstring;

            n0.fil00_codigo           :=ffil00_codigo.AsInteger;
            n0.fil00_descri           :=ffil00_descri.AsString;
            n0.fil00_logr             :=ffil00_logr.AsString  ;
            n0.fil00_nlogr            :=ffil00_nlogr.AsString;
            n0.fil00_bairro           :=ffil00_bairro.AsString;
            n0.fil00_codibge          :=ffil00_codibge.AsInteger;
            n0.fil00_mun              :=ffil00_mun.AsString;
            n0.fil00_uf               :=ffil00_uf.AsString;
            n0.fil00_ufcod		  		  :=CInt(ffil00_ufcod.AsString);
            n0.fil00_cep              :=Tnfeutil.LimpaNumero(ffil00_cep.AsString);
            n0.fil00_ddd              :=LeftStr(Tnfeutil.LimpaNumero(ffil00_ddd.AsString,False),2);
            n0.fil00_fone             :=ffil00_fone.AsString;
            n0.fil00_cgc              :=GetNumbers(ffil00_cgc.AsString);
            n0.fil00_insest           :=GetNumbers(ffil00_insest.AsString);
            n0.fil00_sigla            :=StrUtils.IfThen(ffil00_sigla.AsString<>'','emitente',ffil00_sigla.AsString);
            n0.fil00_nfesmtphost			:=ffil00_nfesmtphost.AsString	;
            n0.fil00_nfesmtpport			:=ffil00_nfesmtpport.AsInteger;
            n0.fil00_nfesmtpuser			:=ffil00_nfesmtpuser.AsString	;
            n0.fil00_nfesmtppass			:=ffil00_nfesmtppass.AsString	;
            n0.fil00_nfesmtpmail			:=ffil00_nfesmtpmail.AsString	;
            n0.fil00_codcou           :=ffil00_codcou.AsInteger;

            n0.cli00_codigo           :=fcli00_codigo.AsInteger;
            n0.cli00_rzsoci           :=fcli00_rzsoci.AsString;
            n0.cli00_fantas           :=fcli00_fantas.AsString;
            n0.cli00_logr             :=fcli00_logr  .AsString;
            if fcli00_nlogr.AsString<>'' then
            begin
            		n0.cli00_nlogr            :=fcli00_nlogr.AsString;
            end
            else begin
              	n0.cli00_nlogr            :='S/N';
            end;
            if fcli00_bairro.AsString<>'' then
            begin
                n0.cli00_bairro       :=fcli00_bairro.AsString;
            end
            else begin
                n0.cli00_bairro       :='CENTRO';
            end;
            n0.cli00_codcid           :=fcli00_codcid   .AsInteger  ;
            n0.cli00_codibge          :=fcli00_codibge  .AsInteger  ;
            n0.cli00_mun              :=fcli00_mun      .AsString   ;
            n0.cli00_uf               :=fcli00_uf       .AsString   ;
            n0.cli00_cep              :=Tnfeutil.LimpaNumero(fcli00_cep .AsString + fcli00_nlogr.AsString);
            n0.cli00_ddd              :=LeftStr(Tnfeutil.LimpaNumero(fcli00_ddd.AsString,False),2);
            n0.cli00_fone             :=fcli00_fone.AsString;
            n0.cli00_ciccgc           :=GetNumbers(fcli00_ciccgc.AsString);
            n0.cli00_rginsc           :=GetNumbers(fcli00_rginsc.AsString);
            n0.cli00_typpes           :=TPessoaType(fcli00_typpes.AsInteger)   ;
            n0.cli00_emaildanfe       :=LowerCase(fcli00_emaildanfe.AsString);
            n0.cli00_codcou           :=fcli00_codcou.AsInteger;

            // cobrança
            n0.ffinrecdup00List.CLoad(n0.ntf00_codfil, n0.ntf00_rem_cod_ped);

            // classe fiscal
            //n0.festtipfis01List.CLoad(n0.ntf00_codfil, n0.ntf00_codntf);

            n0.Checked :=True	;
            n0.catalog :=catalog;

        end;

        q.Next;
    end;
    q.Close;
    q.Destroy;
//    errCod.Destroy;
end;

function Testnfelot00List.Testnfelot00.CLoadXML: Boolean;
var
	q:TQueryDBZ;

var
	n:Testnfelot00List.Testnfelot00.Testnotfis00;

var
	fntf00_codfil:TField;
  fntf00_codntf:TField;
  fntf00_nfekey:TField;
  fntf00_nfeemi:TField;
  fntf00_nfestt:TField;
  fntf00_nfexml:TField;

begin

    inherited Clear(True);
    //
    if(lot00_codlot>0)then
    begin
        Self.lot00_codlot :=lot00_codlot;
    end;
    //
    q :=NewQueryDBZ(CDataBase);
    q.sql.Add('select	ntf00_codfil	,          ');
    q.sql.Add('				ntf00_codntf	,          ');
    q.sql.Add('				ntf00_nfekey	,          ');
    q.sql.Add('      	ntf00_nfeemi	,          ');
    q.sql.Add('      	ntf00_nfestt	,          ');
    q.sql.Add('      	ntf00_nfexml             ');
    q.sql.Add('from estnotfis00 (nolock)       ');
    q.sql.Add('where ntf00_nfelot=:ntf00_nfelot');
    q.Param('ntf00_nfelot').AsInteger :=Self.lot00_codlot;
    q.Open;
    Result :=not q.IsEmpty;

    fntf00_codfil :=q.Field('ntf00_codfil');
    fntf00_codntf :=q.Field('ntf00_codntf');
    fntf00_nfekey :=q.Field('ntf00_nfekey');
    fntf00_nfeemi :=q.Field('ntf00_nfeemi');
    fntf00_nfestt :=q.Field('ntf00_nfestt');
    fntf00_nfexml :=q.Field('ntf00_nfexml');

    while not q.Eof do
    begin

        n	:=Self.IndexOfByCOD(fntf00_codntf.AsInteger);
        if n = nil then
        begin
            n             	:=Self.CreateNew;
            n.ntf00_codfil	:=fntf00_codfil.AsInteger;
            n.ntf00_codntf	:=fntf00_codntf.AsInteger;
            n.ntf00_nfekey	:=fntf00_nfekey.AsString;
            n.ntf00_nfeemi  :=TnfeEmis(fntf00_nfeemi.AsInteger);
            n.ntf00_nfestt  :=fntf00_nfestt.AsInteger;
            n.ntf00_nfexml	:=fntf00_nfexml.AsString;
        end;

        q.Next;
    end;
    q.Close;
    q.Destroy;

end;

function Testnfelot00List.Testnfelot00.ConsultarReci(out retMsg: string): Boolean;
//var ws:TnfeRetRecepcao;
var ws:TNFeRetRecepcao2;
var infProt:TinfProt;
var n:Testnotfis00;
var i:Integer;
var f:TfilterNfe	;
var cp: Boolean ;
begin
//    ws :=TnfeRetRecepcao.Create(fconfigNFe);
    ws :=TNFeRetRecepcao2.Create;
    try

        //ws.SaveXML :=True ;
        ws.Recibo :=Self.lot00_retrec;
        ws.XMLSave  :=LocalConfigNFe.saveXML ;
        Result    :=ws.Execute;
        retMsg    :=ws.FormatMsg;

        Self.RegisterSttLote(ws.tpAmb,
                             ws.verAplic,
                             ws.cStat,
                             ws.xMotivo,
                             ws.cUF);

        if Result then
        begin
//            frmAppEvent.Add('Carrega filtro: lote=%d',[Self.lot00_codlot]);
            f.lot1 :=Self.lot00_codlot;
            f.lot2 :=Self.lot00_codlot;
            if Self.CLoad(f) then
            begin
              for i :=0 to ws.retConsReciNFe.Count -1 do
              begin
                  infProt :=ws.retConsReciNFe.Items[i];
                  n       :=Self.IndexOfByKEY(infProt.chNFe);
                  if n<>nil then
                  begin
                      n.DoRegisterSitNFe(infProt.cStat   ,
                                         infProt.xMotivo ,
                                         infProt.nProt   ,
                                         infProt.dhRecbto,
                                         infProt.digVal
                                         );

                      // se autorizada ou em duplicidade
                      if infProt.cStat in[TNFe.COD_AUT_USO_NFE,TNFe.COD_REJ_DUPLI_NFE]then
                      begin
                        	//envia por e-mail para o rem/dest
                          n.SendMail(retMsg) ;

                          //salva uma copia
                          if DirectoryExists(fconfigNFe.localnfe) then
                          begin
                              cp :=n.SaveXmlToFile(LayNfe, fconfigNFe.localnfe);
                              n.DoRegisterCopyNFe(cp);
                          end;
                      end ;
                      // salva cada NF-e em disco para posterior analise do erro
//                      else
//                      begin
//                          n.SaveXmlToFile(LayNfe, PathNFEXMLErr);
//                      end;
                  end;
//                  else
//                    frmAppEvent.Add('NFe não processou!');
              end;
              Self.CLoad(f);
            end;
//            else
//              frmAppEvent.Add('Não retornou dados!');

        end;
        {else begin
            Self.RegisterSitNFe(ws.CodStt, ws.Motivo);
            // salva o lote em disco para posterior analise do erro
            if ws.CodStt<>105 then
            begin
                Self.SaveXmlToFile;
            end;
        end;}
    finally
        ws.Destroy;
    end;
end;

constructor Testnfelot00List.Testnfelot00.Create;
begin
    inherited Create;
    fconfigNFe  :=TconfigNFe.Create;
//    ulog.DoInit(nil);
end;

function Testnfelot00List.Testnfelot00.CreateNew: Testnotfis00;
begin
     Result         :=Testnotfis00.Create;
     Result.CParent :=Self;
     Result.Index   :=Self.Count;
     inherited Add(Result);
end;

procedure Testnfelot00List.Testnfelot00.Delete(Index:Integer);
var Q:TQueryDBZ;
var N:Testnfelot00List.Testnfelot00.Testnotfis00;
begin
    N:=inherited Items[Index];
    if Assigned(N) then
    begin
        Q:=NewQueryDBZ(CDataBase);
        Q.sql.add('update estnotfis00 set     ');
        Q.sql.add('       ntf00_nfelot=00     ');
        Q.sql.add('       ,ntf00_nfekey=null  ');
        Q.sql.add('       ,ntf00_nfestt=null  ');
        Q.sql.add('       ,ntf00_nfeemi=null  ');
        Q.sql.add('       ,ntf00_nfexml=null  ');
        Q.sql.add('       ,ntf00_nfemot=null  ');
        Q.sql.add('where ntf00_codfil=%d      ',[N.ntf00_codfil ]);
        Q.sql.add('and   ntf00_codtyp=%d      ',[N.ntf00_codtyp ]);
        Q.sql.add('and   ntf00_codntf=%d      ',[N.ntf00_codntf ]);
        Q.ExecSQL;
        Q.Destroy;
        inherited Remove(N);
    end;
end;

destructor Testnfelot00List.Testnfelot00.Destroy;
begin
    fconfigNFe.Destroy;
//    ulog.DoFinaly ;
    inherited Destroy;
end;

procedure Testnfelot00List.Testnfelot00.DoGer(out retCod: Integer;
  out retMsg: string);
var n:Testnfelot00List.Testnfelot00.Testnotfis00;
var f:TfilterNfe;
var i:Integer;
begin
    retCod :=0 ;
    retMsg :='';

    fLoteStr :='';

  	f.lot1 :=Self.lot00_codlot;
    f.lot2 :=Self.lot00_codlot;
    Self.CLoad(f);

    for i :=0 to Self.Count -1 do
    begin
        n :=Self.Items[i];
        n.DoFillXML;

        if n.ntf00_nfestt = TNFe.COD_DON_ENVIO then
        begin
            fLoteStr :=fLoteStr + n.NFe.XML;
        end
        else begin

            if not n.NFe.Assinar(fconfigNFe.GetCertificado, retMsg) then
            begin
                retCod :=297;
                retMsg :='Erro de assinatura!'#13 +retMsg ;
                Break;
            end;

            if n.NFe.Validar(retCod, retMsg, fconfigNFe.localschema) then
            begin
                n.DoRegisterSitNFe(TNFe.COD_DON_ENVIO,'NF-e bem formatada e pronto para envio.');
                fLoteStr :=fLoteStr + n.NFe.XML;
            end
            else begin
                n.DoRegisterSitNFe(retCod, retMsg);
                retMsg  :=Format('%d|%s',[retCod, retMsg]);
                retMsg  :=Format('Falha na validação dos dados no lote:%d!'#13'%s',[lot00_codlot, retMsg]);
                Break;
            end;

        end ;
    end;

    if retCod in[TNFe.COD_REJ_XML_MAU_FORMADO,TNFe.COD_REJ_FALHA_SCHEMA_XML] then
    begin
        Self.RegisterSttLote(fconfigNFe.typAmb ,
                              '',
                              retCod,
                              'Rejeição: Falha no schema XML',
                              fconfigNFe.emit.ufCodigo);
    end;
end;

function Testnfelot00List.Testnfelot00.Enviar(out retMsg: string): Boolean;
{.$IFDEF NFCE}
var ws:TNFeRecepcao2;
{.$ELSE}
//var ws:TnfeRecepcao;
{.$ENDIF}
var ss:AnsiString;
var cc:Integer;
var n:Testnotfis00;
begin
    Result :=False ;

    DoGer(cc, retMsg);
    if cc = 0 then
    begin
        //pendentes de retorno
        {Self.RegisterSttLote( fconfigNFe.typAmb,
                              NFE_VER_APP ,
                              TNFe.COD_PEN_RETORNO,
                              'Pendente de retorno!',
                              fconfigNFe.emit.ufCodigo);}
        {.$IFDEF NFCE}
        ws  :=TNFeRecepcao2.Create;
        try
            ws.Lote     :=lot00_codlot;
            ws.dadosMsg :=fLoteStr;
            ws.IndSinc  :=(Self.Count > 1) ;
            ws.XMLSave  :=LocalConfigNFe.saveXML ;
            Result      :=ws.Execute;
            retMsg      :=ws.FormatMsg;
            if Result then
            begin
                Self.RegisterSttLote( ws.tpAmb,
                                      ws.verAplic,
                                      ws.cStat,
                                      ws.xMotivo,
                                      ws.cUF,
                                      ws.Recibo,
                                      ws.dhRecbto);

                if ws.ProtNFe.cStat > 0 then
                begin
                    n :=Self.Items[0] ;
                    n.DoRegisterSitNFe(ws.ProtNFe.cStat   ,
                                       ws.ProtNFe.xMotivo ,
                                       ws.ProtNFe.nProt   ,
                                       ws.ProtNFe.dhRecbto,
                                       ws.ProtNFe.digVal  ,
                                       ws.ProtNFe.verAplic);
                end;
            end;
        finally
            ws.Destroy;
        end;
        {.$ELSE}
//        ws  :=TnfeRecepcao.Create(Self.fconfigNFe);
//        try
//            ws.PathXML :=PathNFEXMLErr;
//            ws.SaveXML :=LocalConfigNFe.saveXML ;
//            ws.Lote     :=lot00_codlot;
//            ws.dadosMsg :=fLoteStr;
//
//            Result      :=ws.Execute;
//            retMsg      :=ws.msg;
//            if Result then
//            begin
//                Self.RegisterSttLote( ws.TypAmb,
//                                      ws.VerApp,
//                                      ws.CodStt,
//                                      ws.Motivo,
//                                      ws.UF,
//                                      ws.Recibo,
//                                      ws.dhRecbto);
//            end;
//        finally
//            ws.Destroy;
//        end;
        {.$ENDIF}

    end;

end;

function Testnfelot00List.Testnfelot00.ExistCHK: Boolean;
var i:Integer;
begin
     Result:=False;
     for i:=0 to Self.Count-1 do
     begin
          if Self.Items[i].Checked then
          begin
               Result:=True;
               Break;
          end;
     end;
end;

procedure Testnfelot00List.Testnfelot00.Gerar;
var i:Integer;
var n:Testnfelot00List.Testnfelot00.Testnotfis00;
var f:TfilterNfe;
begin
  	f.lot1 :=Self.lot00_codlot	;
    f.lot2 :=Self.lot00_codlot	;
    Self.CLoad(f)	;
    for i :=0 to Self.Count -1 do
    begin
        n :=Self.Items[i];
        n.DoFillXML;
    end;
end;

function Testnfelot00List.Testnfelot00.Get(Index: Integer): Testnotfis00;
begin
     Result:=inherited Items[Index];

end;

procedure Testnfelot00List.Testnfelot00.Imprimir(const printerName: string;
  const printerHost: string);
var i:Integer;
var n:Testnfelot00List.Testnfelot00.Testnotfis00;
var s:TOutiputDanfe;
var f,m:string;
begin
    //
    case fconfigNFe.danfe.saida of
        1:s :=odPrinter;
        2:s :=odFile   ;
    else
        s   :=odPreview;
    end;
    //
    for i :=0 to Self.Count -1 do
    begin
        n :=Self.Items[i];

        n.Checked :=(n.ntf00_nfestt in[TNFe.COD_AUT_USO_NFE, TNFe.COD_REJ_DUPLI_NFE])or
                    (n.ntf00_nfeemi in[emisCon_FS,emisCon_FSDA]) ;
        if n.Checked then
        begin
//            if printerHost<>'' then
//            begin
//              n.PrintDANFE(odFile, '', fconfigNFe.danfe.copias, f, m);
//              DoPrintDirect(f, printerName, fconfigNFe.danfe.copias);
//            end
//            else
              n.PrintDANFE(s, printerName,fconfigNFe.danfe.copias,f,m);
        end;
    end;
end;

function Testnfelot00List.Testnfelot00.IndexOfByCOD(
	const ntf00_codntf: Integer): Testnfelot00List.Testnfelot00.Testnotfis00;
var i:Integer;
begin
     Result:=nil;
     for i:=0 to Self.Count - 1 do
     begin
          if Items[i].ntf00_codntf=ntf00_codntf then
          begin
               Result :=Items[i];
               Break;
          end;

     end;
end;

function Testnfelot00List.Testnfelot00.IndexOfByKEY(
  const ntf00_nfekey: string):Testnfelot00List.Testnfelot00.Testnotfis00;
var i:Integer;
begin
     Result:=nil;
     for i:=0 to Self.Count - 1 do
     begin
          if Items[i].ntf00_nfekey=ntf00_nfekey then
          begin
               Result	:=Items[i];
               Break;
          end;

     end;
end;

procedure Testnfelot00List.Testnfelot00.KillLOT;
var Q:TQueryDBZ;
begin

//    Self.CLoad() ;


    Q:=NewQueryDBZ(CDataBase);
    Q.sql.add('declare @ntf00_nfelot int ; set @ntf00_nfelot = %d            ',[lot00_codlot]) ;

    Q.sql.add('begin tran               																	   ');

    Q.sql.add('begin try               																		   ');
    Q.sql.add('		if exists(select ntf00_nfekey from estnotfis00             ');
    Q.sql.add('		          where ntf00_nfelot=@ntf00_nfelot                 ');
    Q.sql.add('		          and   ntf00_nfestt in(100,101,102,204)           ');
    Q.sql.add('		          and   isnull(ntf00_nferetcon,'''')<>'''')        ');
    Q.sql.add('		begin                                                      ');
    Q.sql.add('				raiserror(''Existe notas autorizadas/canceladas/inutilizadas no lote!'',10,1)');
    Q.sql.add('		end ;                                                      ');

    Q.sql.add('    update estnotfis00 set                                    ');
    Q.sql.add('          ntf00_nfelot=00                                     ');
    Q.sql.add('          ,ntf00_nfekey=null                                  ');
    Q.sql.add('          ,ntf00_nfestt=null                                  ');
    Q.sql.add('          ,ntf00_nfeemi=null                                  ');
    Q.sql.add('          ,ntf00_nfexml=null                                  ');
    Q.sql.add('          ,ntf00_nfemot=null                                  ');
    Q.sql.add('    where ntf00_nfelot=@ntf00_nfelot                          ');
    Q.sql.add('                                                              ');
    Q.sql.add('    delete from estnfelot00                                   ');
    Q.sql.add('    where lot00_codlot=@ntf00_nfelot                          ');
    q.SQL.Add('end try                                                       ');

    q.sql.Add('begin catch                                                    ');
    q.sql.Add('		if @@trancount > 0  rollback tran                           ');
    q.sql.Add('end catch ;                                                    ');
    q.sql.Add('if @@trancount > 0 commit tran ;                               ');
    Q.ExecSQL;
    Q.Destroy;
end;

function Testnfelot00List.Testnfelot00.SaveXmlToFile: Boolean;
var F:TfilterNfe ;
var L:string;
var I:Integer;
var X:String;
begin

    if Self.Count = 0 then
    begin
        F.lot1 :=lot00_codlot;
        F.lot2 :=lot00_codlot;
        Self.CLoad(F);
    end;

    L :='<?xml version="1.0" encoding="utf-8"?>';
    L :=L + '<enviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.10">';
    L :=L + Format('<idLote>%d</idLote>', [lot00_codlot]);

    for I :=0 to Self.Count -1 do
    begin
        X :=Self.Items[I].ntf00_nfexml;
        if X <> '' then
        begin
            L :=L +X;
        end;
    end;

    L :=L + '</enviNFe>';
    //F :=Tnfeutil.PathApp +Format('config\nfe\xmlerror\%d-envi-lot.xml',[lot00_codlot]);
    //Result  :=unfexml.SaveXmlToFile(L, F);
    Result :=TNativeXml.SaveXmlToFile(L, Tnfeutil.PathApp +Format('config\nfe\xmlerror\%d-envi-lot.xml',[lot00_codlot]));
end;

function Testnfelot00List.Testnfelot00.Validar( out codStt: Integer;
                                                out motStt: String): Boolean;
var i: Integer;
var n: Testnfelot00List.Testnfelot00.Testnotfis00;
begin
    codStt  :=000;
    Result  :=False;

    for i :=0 to Self.Count -1 do
    begin
        n :=Self.Items[i];
        if((n.ntf00_nfestt =TNFe.COD_DON_ENVIO)and(n.ntf00_nfeemi in[emisCon_FS,emisCon_FSDA]))then
        begin
            Result :=True ;
        end
        else begin

            Result:=n.NFe.Validar(codStt, motStt, fconfigNFe.localschema);

            if Result then
            begin
                n.DoRegisterSitNFe(TNFe.COD_DON_ENVIO, 'Pronto para envio.');
            end
            else begin
                n.DoRegisterSitNFe(codStt, motStt);
                Break;
            end;
        end;
    end;

    if not Result then
    begin
        Self.RegisterSttLote(fconfigNFe.typAmb ,
                              '',
                              215,
                              'Rejeição: Falha no schema XML',
                              fconfigNFe.emit.ufCodigo);
    end;
end;

procedure Testnfelot00List.Testnfelot00.RegisterSitNFe(
  const lot00_comstt: Integer; const lot00_commot: string);
var q:TQueryDBZ;
begin
    q:=NewQueryDBZ(CDataBase);
    q.sql.Add('update estnotfis00 set             ');
    q.sql.add('      ntf00_nfestt   =%d           ',[ lot00_comstt      ]);
    q.sql.add('     ,ntf00_nfemot   =''%s''       ',[ lot00_commot      ]);

    q.sql.add('where ntf00_nfelot   = %d          ',[ Self.lot00_codlot ]);
    q.ExecSQL;
    q.Destroy;
end;

procedure Testnfelot00List.Testnfelot00.RegisterSttLote(const lot00_comabm: TnfeAmb;
                                                        const lot00_comapp: string;
                                                        const lot00_comstt: Integer;
                                                        const lot00_commot: string;
                                                        const lot00_comest: Integer;
                                                        const lot00_retrec: string;
                                                        const lot00_retdat: Tdatetime);
var q:TQueryDBZ;
begin
    Self.lot00_comabm :=Tnfeutil.SeSenao(lot00_comabm=ambPro,1,2);
    Self.lot00_comapp :=lot00_comapp;
    Self.lot00_comstt :=lot00_comstt;
    Self.lot00_commot :=lot00_commot;
    Self.lot00_comest :=lot00_comest;

    q :=NewQueryDBZ(CDataBase);
    q.sql.add('begin tran                                 ');
    q.SQL.Add('begin try                                  ');
    q.sql.add('update estnfelot00 set                     ');
    q.sql.add('      lot00_comstt=  %d                    ',[ lot00_comstt      ]);
    q.sql.add('      ,lot00_commot=''%s''                 ',[ lot00_commot      ]);

    if lot00_comstt = 103 then
    begin
        q.sql.add('      ,lot00_comabm=  %d               ',[ Ord (lot00_comabm)]);
        q.sql.add('      ,lot00_comapp=''%s''             ',[ lot00_comapp      ]);
        q.sql.add('      ,lot00_comest=  %d               ',[ lot00_comest      ]);
        //
        Self.lot00_retrec :=lot00_retrec;
        Self.lot00_retdat :=lot00_retdat;
        Q.sql.add('     ,lot00_retrec=''%s''              ',[ lot00_retrec                  ]);
        Q.sql.add('     ,lot00_retdat=  %s                ',[ Q.SQLFun.SDatSQL(lot00_retdat)]);
    end ;
    q.sql.add('where lot00_codlot=  %d                    ',[ Self.lot00_codlot]);
    //
		if lot00_comstt in[99,103] then
    begin
        q.sql.Add('update estnotfis00 set                 ');
        q.sql.add('      ntf00_nfestt   =%d               ',[ lot00_comstt     ]);
        q.sql.add('     ,ntf00_nfemot   =''%s''           ',[ lot00_commot     ]);
        q.sql.add('where ntf00_nfelot   = %d              ',[ Self.lot00_codlot]);
    end;
    //
    q.sql.Add('end try                                    ');
    q.sql.Add('begin catch                                ');
    q.sql.Add('		if @@trancount > 0  rollback tran       ');
    q.sql.Add('end catch ;                                ');
    q.sql.Add('if @@trancount > 0 commit tran ;           ');
    //
    q.ExecSQL;
    q.Destroy;
end;

function Testnfelot00List.Testnfelot00.Remover(out retMsg: string): Boolean;
var Q:TQueryDBZ;
var F:TfilterNfe ;
var N:Testnfelot00List.Testnfelot00.Testnotfis00;
var I:Integer ;
begin
    Result :=True ;
  	F.lot1 :=Self.lot00_codlot;
    F.lot2 :=Self.lot00_codlot;
    if Self.CLoad(F) then
    begin
        for I := 0 to Self.Count - 1 do
        begin
          	N :=Self.Items[I] ;
            if(N.ntf00_nfestt=TNFe.COD_DEN_USO_NFE)or
              (N.ntf00_nfestt=TNFe.COD_DEN_USO_EMIT)or
              (N.ntf00_nfestt=TNFe.COD_DEN_USO_DEST)then
            begin
                Result :=False ;
                retMsg :=Format('%d|Uso Denegado',[TNFe.COD_DEN_USO_NFE]);
            end
            else if N.ntf00_nfestt=TNFe.COD_INU_HOM_NFE then
            begin
                Result :=False ;
                retMsg :=Format('%d|Inutilização de número homologado',[TNFe.COD_INU_HOM_NFE]);
            end
            else if N.ntf00_nfestt=TNFe.COD_CAN_HOM_NFE then
            begin
                Result :=False ;
                retMsg :=Format('%d|Cancelamento de NF-e homologado',[TNFe.COD_CAN_HOM_NFE]);
            end
            else if N.ntf00_nfestt in[TNFe.COD_AUT_USO_NFE,TNFe.COD_REJ_DUPLI_NFE] then
            begin
                Result :=False ;
                retMsg :=Format('%d|Autorizado o uso da NF-e',[TNFe.COD_AUT_USO_NFE]);
            end;
        end;

        if Result then
        begin
          Q:=NewQueryDBZ(CDataBase);
          Q.sql.add('declare @ntf00_nfelot int ; set @ntf00_nfelot = %d',[lot00_codlot]) ;
          Q.sql.add('begin tran               												 ');
          Q.sql.add('begin try               													 ');
          Q.sql.add('    update estnotfis00 set                        ');
          Q.sql.add('          ntf00_nfelot=00                         ');
          Q.sql.add('          ,ntf00_nfekey=null                      ');
          Q.sql.add('          ,ntf00_nfestt=0                         ');
          Q.sql.add('          ,ntf00_nfeemi=null                      ');
          Q.sql.add('          ,ntf00_nfexml=null                      ');
          Q.sql.add('          ,ntf00_nfemot=null                      ');
          Q.sql.add('    where ntf00_nfelot=@ntf00_nfelot              ');
          Q.sql.add('                                                  ');
          Q.sql.add('    delete from estnfelot00                       ');
          Q.sql.add('    where lot00_codlot=@ntf00_nfelot              ');
          q.SQL.Add('end try                                           ');
          q.sql.Add('begin catch                                       ');
          q.sql.Add('		if @@trancount > 0  rollback tran              ');
          q.sql.Add('end catch ;                                       ');
          q.sql.Add('if @@trancount > 0 commit tran ;                  ');
          Q.ExecSQL;
          Q.Destroy;
        end
        else begin
        	retMsg :='Existe NF-e no lote com a siguinte situação: '+retMsg	;
        end;
    end
    else begin
      Q:=NewQueryDBZ(CDataBase);
      Q.sql.add('declare @ntf00_nfelot int ; set @ntf00_nfelot = %d',[lot00_codlot]) ;
      Q.sql.add('begin tran               												 ');
      Q.sql.add('begin try               													 ');
      Q.sql.add('    delete from estnfelot00                       ');
      Q.sql.add('    where lot00_codlot=@ntf00_nfelot              ');
      q.SQL.Add('end try                                           ');
      q.sql.Add('begin catch                                       ');
      q.sql.Add('		if @@trancount > 0  rollback tran              ');
      q.sql.Add('end catch ;                                       ');
      q.sql.Add('if @@trancount > 0 commit tran ;                  ');
      Q.ExecSQL;
      Q.Destroy;
    end;
end;

{ Testnfelot00List }

function Testnfelot00List.Get(Index:Integer):Testnfelot00;
begin
     Result:=inherited Items[Index];
end;

procedure Testnfelot00List.CLoad(filter: TFilterLot);
var Q:TQueryDBZ;
var C:Testnfelot00;

var flot00_codlot:TField;
var flot00_codusr:TField;
var flot00_datsys:TField;
var flot00_datret:TField;
var flot00_status:TField;
var flot00_comabm:TField;
var flot00_nfeemi:TField;
var flot00_comapp:TField;
var flot00_comstt:TField;
var flot00_commot:TField;
var flot00_comest:TField;
var flot00_retrec:TField;
var flot00_retdat:TField;
var flot00_lotcon:TField;
//var flot00_scrxmlger:TField;

begin
    Self.Clear;

    Q:=NewQueryDBZ(CDataBase);

    try
				//Q.SQL.Add('select*from estnfelot00(nolock)                           ');
        Q.SQL.Add('select	lot00_codlot ,                                    ');
        Q.SQL.Add('  lot00_codusr      ,                                    ');
        Q.SQL.Add('  lot00_datsys      ,                                    ');
        Q.SQL.Add('  lot00_datret      ,                                    ');
        Q.SQL.Add('  lot00_status      ,                                    ');
        Q.SQL.Add('  lot00_comabm      ,                                    ');
        Q.SQL.Add('  lot00_nfeemi      ,                                    ');
        Q.SQL.Add('  lot00_comapp      ,                                    ');
        Q.SQL.Add('  lot00_comstt      ,                                    ');
        Q.SQL.Add('  lot00_commot      ,                                    ');
        Q.SQL.Add('  lot00_comest      ,                                    ');
        Q.SQL.Add('  lot00_retrec      ,                                    ');
        Q.SQL.Add('  lot00_retdat                                           ');
        Q.SQL.Add('from estnfelot00(nolock)                                 ');
        if filter.codgrp > 0 then
        begin
        		Q.sql.Add('where lot00_codgrp = %d                 					 		 ',[filter.codgrp]);
        end
        else begin
            if filter.lot1 > 0 then
            begin
              Q.sql.Add('where lot00_codlot between %d and %d                    ',[filter.lot1,filter.lot2]);
            end
            else begin
                Q.sql.Add('where	lot00_codfil = %d                 						 ',[filter.cfil]);
                Q.sql.Add('and		lot00_datsys between %s and %s                 ',[Q.SQLFun.SDatSQL(filter.dta1),Q.SQLFun.SDatSQL(filter.dta2,True)]);

                if filter.emi in[emisCon_FS,emisCon_FSDA] then
                begin
                    Q.SQL.Add('and lot00_nfeemi	=%d ',[Ord(filter.emi)]);
                end
                else begin
                    Q.SQL.Add('and lot00_nfeemi	=%d ',[Ord(filter.emi)]);
                    // Não enviados
                    if filter.stt = 0 then
                    begin
                        Q.SQL.Add('and lot00_comstt=0                            ');
                    end

                    // Lote recebido com sucesso
                    else if filter.stt = 103 then
                    begin
                        Q.SQL.Add('and lot00_comstt=103                          ');
                    end

                    // Lote processado
                    else if filter.stt = 104 then
                    begin
                        Q.SQL.Add('and lot00_comstt=104                          ');
                    end

                    // Lote em processamento
                    else if filter.stt = 105 then
                    begin
                        Q.SQL.Add('and lot00_comstt=105                          ');
                    end

                    // Rejeição
                    else if filter.stt >= 201 then
                    begin
                        Q.SQL.Add('and lot00_comstt >= 201                       ');
                    end

                    // pentente de retorno
                    else if filter.stt = 99 then
                    begin
                        Q.SQL.Add('and lot00_comstt=99                           ');
                    end;
                end;
            end;
        end;

        Q.SQL.Add('order by lot00_codlot desc                                ');
        Q.Open;

        flot00_codlot:=Q.Field('lot00_codlot');
        flot00_codusr:=Q.Field('lot00_codusr');
        flot00_datsys:=Q.Field('lot00_datsys');
        flot00_datret:=Q.Field('lot00_datret');
        flot00_status:=Q.Field('lot00_status');
        flot00_comabm:=Q.Field('lot00_comabm');
        flot00_nfeemi:=Q.Field('lot00_nfeemi');
        flot00_comapp:=Q.Field('lot00_comapp');
        flot00_comstt:=Q.Field('lot00_comstt');
        flot00_commot:=Q.Field('lot00_commot');
        flot00_comest:=Q.Field('lot00_comest');
        flot00_retrec:=Q.Field('lot00_retrec');
        flot00_retdat:=Q.Field('lot00_retdat');
//        flot00_scrxmlger:=Q.Field('lot00_scrxmlger');
//        flot00_lotcon:=Q.Field('lot00_lotcon');

        while not Q.Eof do
        begin
          c:=Self.CreateNew;
          c.lot00_codlot:=                  flot00_codlot.AsInteger   ;
          c.lot00_codusr:=                  flot00_codusr.AsInteger   ;
          c.lot00_datsys:=                  flot00_datsys.AsDateTime  ;
          c.lot00_datret:=                  flot00_datret.AsDateTime  ;
          c.lot00_status:=Testnfelot00Stt ( flot00_status.AsInteger ) ;
          c.lot00_comabm:=TnfeAmb(flot00_comabm.AsInteger) ;
          c.lot00_nfeemi:=                  TnfeEmis(flot00_nfeemi.AsInteger);
          c.lot00_comapp:=                  flot00_comapp.AsString    ;
          c.lot00_comstt:=                  flot00_comstt.AsInteger   ;
          c.lot00_commot:=                  flot00_commot.AsString    ;
          c.lot00_comest:=                  flot00_comest.AsInteger   ;
          c.lot00_retrec:=                  flot00_retrec.AsString    ;
          c.lot00_retdat:=                  flot00_retdat.AsDateTime  ;
//          c.lot00_scrxmlger:=               flot00_scrxmlger.AsString ;
//          c.lot00_lotcon:=                  flot00_lotcon.AsInteger   ;

          Q.Next;
        end;
    finally
      Q.Destroy;
    end;
end;

function Testnfelot00List.IndexOf(lot00_codlot:Integer):Testnfelot00;
var i:Integer;
begin
     Result:=nil;
     for i:=0 to Self.Count-1 do
     begin
          if Self.Items[i].lot00_codlot=lot00_codlot then
          begin
               Result:=Self.Items[i];
               Break;
          end;
     end;
end;

function Testnfelot00List.Exist(lot00_codlot:Integer):Boolean;
begin
     Result:=Self.IndexOf(lot00_codlot)<>nil;
end;

function Testnfelot00List.CreateNew:Testnfelot00;
begin
     Result         :=Testnfelot00.Create;
     Result.CParent :=Self;
     Result.Index   :=Self.Count;
     inherited Add(Result);
end;

function Testnfelot00List.ExistCHK: Boolean;
var i:Integer;
begin
     Result:=False;
     for i:=0 to Self.Count-1 do
     begin
          if Self.Items[i].Checked then
          begin
               Result:=True;
               Break;
          end;
     end;
end;

function Testnfelot00List.ToArrayString(JustCHK:Boolean=True): string;
var i:Integer;
begin
     Result:='-1,';
     if JustCHK then
     begin
          if ExistCHK then
          begin
               Result:='';
               for i:= 0 to Self.Count-1 do
               begin
                    if Items[i].Checked then
                    begin
                         Result:=SFmt('%s%d,',[Result,Items[i].lot00_codlot]);
                    end;
               end;
          end;
     end
     else if Self.Count>0 then
     begin
          Result:='';
          for i:= 0 to Self.Count-1 do
          begin
               Result:=SFmt('%s%d,',[Result,Items[i].lot00_codlot]);

          end;
     end;
     Result:=Copy(Result,1,length(Result)-1);

end;

{ Testnfelot00List.Testnfelot00.Testnotfis00 }

function Testnfelot00List.Testnfelot00.Testnotfis00.CCancelNFe(
  const AJust: string; out AErr: string): Boolean;
//var ws:TnfeCancelamento;
//var ret:Integer;
var evt: Testeventonfe00;
var cod: Integer;
var msg: string ;
begin
{    ws:=TnfeCancelamento.Create(Self.CParent.fconfigNFe);
    try
      ws.NFeKey :=Self.ntf00_nfekey;
      ws.NProt  :=Self.ntf00_nferetcon;
      ws.Just   :=AJust;
      Result    :=ws.Execute;
      AErr      :=ws.msg;
      if Result then
      begin
        	try
          		Self.DoRegisterInfCancNFe(	ws.Versao ,
                                          ws.TypAmb ,
                                          ws.VerApp ,
                                          ws.CodStt ,
                                          ws.Motivo ,
                                          ws.UF     ,
                                          ws.NFeKey ,
                                          ws.dhRecbto,
                                          ws.NProt ,
                                          ws.Just);
          except
							AErr :=AErr + #13'%d|Erro ao gravar protocolo de cancelamento na base local!';
          end;
      end;
    finally
        ws.Destroy;
    end;}
    Result :=False ;
    evt :=Testeventonfe00.Create(usNewValue);
    try
        evt.evt00_codseq :=ntf00_codseq;
        evt.evt00_codfil :=ntf00_codfil;
        evt.evt00_codtyp :=ntf00_codtyp;
        evt.evt00_codntf :=ntf00_codntf;
        evt.evt00_codusr :=estusr00.usr00_codigo;
        evt.evt00_codorg :=fil00_ufcod;
        evt.evt00_tipamb :=ntf00_nfeamb;
        evt.evt00_cnpj   :=fil00_cgc;
        evt.evt00_chvnfe :=ntf00_nfekey;
        evt.evt00_datevt :=GetSysDate(CDataBase);
        evt.evt00_tipevt :=TnfeEvento.EVT_TYP_CAN;
        evt.evt00_seqevt :=1;
        evt.evt00_xtexto :=AJust;
        evt.evt00_nprotaut:=ntf00_nferetcon;
        evt.DoSend(cod, AErr);
        if cod =TnfeEvento.COD_EVT_VINC_NFE then
        begin
            Result :=True ;
            if not evt.ApplyUpdates(cod, msg) then
            begin
                AErr :=AErr +msg;
            end;
        end;
    finally
        evt.Free;
    end;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.CConsSitNFe(out AErr: string): Boolean;
//var ws:TnfeConsulta;
var ws:TNFeConsulta2;
//var lastEvt: Integer ;
var procEvt: TnfeProcEvento;
var evt: Testeventonfe00;
var cod: Integer ;
var msg: string ;
begin
    {ws :=TnfeConsulta.Create(Self.CParent.fconfigNFe);
    try
      ws.TypAmb :=Self.CParent.fconfigNFe.typAmb;
      ws.NFeKey :=Self.ntf00_nfekey;
      Result    :=ws.Exec();
      AErr      :=ws.msg;

      if Result then
      begin
          case ws.CodStt of
            //100:
            TNFe.COD_AUT_USO_NFE,TNFe.COD_DEN_USO_NFE:
            begin
              Self.DoRegisterSitNFe(ws.CodStt,
                                    ws.Motivo,
                                    ws.retConsSitNFe.ProtNFe.infProt.nProt,
                                    ws.retConsSitNFe.ProtNFe.infProt.dhRecbto,
                                    ws.retConsSitNFe.ProtNFe.infProt.digVal,
                                    ws.VerApp);
            end;

            //101:
            TNFe.COD_CAN_HOM_NFE: Self.DoRegisterInfCancNFe(ws.Versao ,
                                            ws.TypAmb ,
                                            ws.VerApp ,
                                            ws.CodStt ,
                                            ws.Motivo ,
                                            ws.UF     ,
                                            ws.NFeKey ,
                                            ws.retConsSitNFe.RetCancNfe.infCanc.dhRecbto,
                                            ws.retConsSitNFe.RetCancNfe.infCanc.nProt,
                                            '');
            //110:
          end;
      end;

    finally
        ws.Destroy;
    end;}
    ws :=TNFeConsulta2.Create;
    try
      ws.chNFe :=Self.ntf00_nfekey;
      Result   :=ws.Execute();
      AErr     :=ws.FormatMsg;

      if Result then
      begin
          case ws.retConsSitNFe.cStat of
            TNFe.COD_AUT_USO_NFE:
            begin
                Self.DoRegisterSitNFe(ws.retConsSitNFe.cStat,
                                      ws.retConsSitNFe.xMotivo,
                                      ws.retConsSitNFe.protNFe.nProt,
                                      ws.retConsSitNFe.protNFe.dhRecbto,
                                      ws.retConsSitNFe.protNFe.digVal,
                                      ws.retConsSitNFe.protNFe.verAplic);
            end;

            TNFe.COD_CAN_HOM_NFE:
            begin
//                if ws.retConsSitNFe.procEventoNFeList.Count > 1 then
//                  lastEvt :=ws.retConsSitNFe.procEventoNFeList.Count -1
//                else
//                  lastEvt :=0;
//                procEvt :=ws.retConsSitNFe.procEventoNFeList.Items[lastEvt];
                procEvt :=ws.retConsSitNFe.procEventoNFeList.GetLast();
                if procEvt <> nil then
                begin
                    evt :=Testeventonfe00.Create(usNewValue);
                    evt.evt00_codfil :=Self.ntf00_codfil ;
                    evt.evt00_codtyp :=Self.ntf00_codtyp ;
                    evt.evt00_codntf :=Self.ntf00_codntf ;
                    evt.evt00_codusr :=estusr00.usr00_codigo;
                    evt.evt00_codorg :=procEvt.evento.infEvento.cOrgao ;
                    evt.evt00_tipamb :=procEvt.evento.infEvento.tpAmb ;
                    evt.evt00_cnpj   :=procEvt.evento.infEvento.CNPJ ;
                    evt.evt00_chvnfe :=procEvt.evento.infEvento.chNFe ;
                    evt.evt00_datevt :=procEvt.evento.infEvento.dhEvento ;
                    evt.evt00_tipevt :=procEvt.evento.infEvento.tpEvento ;
                    evt.evt00_xtexto :=procEvt.evento.infEvento.detEvento.xJust;
                    evt.evt00_nprotaut:=procEvt.evento.infEvento.detEvento.nProt;
                    evt.evt00_envxml :=procEvt.evento.xml;
                    evt.evt00_codstt :=procEvt.retEvento.cStat;
                    evt.evt00_motstt :=procEvt.retEvento.xMotivo;
                    evt.evt00_dthreg :=procEvt.retEvento.dhRegEvento;
                    evt.evt00_nprotreg:=procEvt.retEvento.nProt;
                    evt.evt00_retxml :=procEvt.retEvento.xml;
                    if not evt.ApplyUpdates(cod, msg) then
                    begin
                      AErr  :=Format('%d|%s',[cod,msg]);
                      Result:=False;
                    end;
                end;
            end;
            //110:
          end;
      end;

    finally
        ws.Destroy;
    end;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.CLoadItems: Boolean;
var q:TQueryDBZ;

var fpro00_codigo   :TField;
var fpro00_codbar   :TField;
var fpro00_descri   :TField;
var fpro00_unidad   :TField;
var fpro00_clsfis   :TField;
var fpro00_indfrac  :TField;
var fpro00_deflotfab:TField;
var fpro00_codncm   :TField;

//
var fntf01_itmproitm   :TField;
var fntf01_itmproqtd   :TField;
var fntf01_itmpropco   :TField;
var fntf01_itmprottl   :TField;
var fntf01_itmsittri   :TField;
var fntf01_itmcodfis   :TField;
var fntf01_itmpericm   :TField;
var fntf01_itmproicm   :TField;
var fntf01_itmcodcfo	 :TField;
var fntf01_itmrbcper   :TField;
var fntf01_itmrbcvlr   :TField;
var fntf01_itmicmsubbas:TField;
var fntf01_itmicmsubtot:TField;
var fntf01_itmicmsubper:TField;
var fntf01_itmperipi   :TField;
var fntf01_itmproipi   :TField;
var fntf01_itmicmszerbs:TField;

var fntf01_itmvlrfre  :TField;
var fntf01_itmvlrdes  :TField;
var fntf01_itmvlrdsp  :TField;
var fntf01_itmicmbas  :TField;

// med
var fntf01_itmpcopmc    :TField;
var fntf01_pronumlotfab :TField;
var fntf01_prodatlotfab :TField;
var fntf01_prodatlotven :TField;

var
    n1:Testnfelot00List.Testnfelot00.Testnotfis00.Testnotfis01;
    cf:Testtipfis01 ;

var
    vol: Boolean	;

    //
    procedure LoadOpt(const codpro: Integer);
    var q:TQueryDBZ;
    begin
      if TMetaData.ObjExists('cadproopt00', 'opt00_optcod') then
      begin
          q :=NewQueryDBZ(CDataBase);
          try
            q.sql.Add('select opt00_optcod from cadproopt00(nolock)');
            q.sql.Add('where opt00_procod =%d and opt00_optcod =11 ', [codpro]);
            q.Open ;
            n1.opt00_optcod :=q.Field('opt00_optcod').AsInteger;
          finally
            q.Close;
            q.Free ;
          end;
      end;
    end;
    //

begin
    //
    inherited Clear(True);

    //
    q :=NewQueryDBZ(CDataBase);
    q.sql.Add('select                                      ');
    q.sql.Add('      pro00_codigo       ,                  ');
    q.sql.Add('      pro00_codbar       ,                  ');
    Q.sql.Add('      pro00_descri       ,                  ');
    q.sql.Add('      pro00_unidad       ,                  ');
    q.sql.Add('      pro00_clsfis       ,                  ');
    q.sql.Add('      pro00_indfrac      ,                  ');
    if TMetaData.ObjExists('cadpro00', 'pro00_deflotfab') then
    begin
      	q.sql.Add('		pro00_deflotfab   ,                  ');
      	q.sql.Add('		ntf01_pronumlotfab,             		 ');
        q.sql.Add('		ntf01_prodatlotfab,                  ');
        q.sql.Add('		ntf01_prodatlotven,                  ');
    end
    else begin
    		q.sql.Add('  null as pro00_deflotfab    ,          ');
      	q.sql.Add('	 null as ntf01_pronumlotfab ,          ');
        q.sql.Add('	 convert(smalldatetime, 0) as ntf01_prodatlotfab,');
        q.sql.Add('	 convert(smalldatetime, 0) as ntf01_prodatlotven,');
    end;

    if TMetaData.ObjExists('cadpro00', 'pro00_codncm') then
    begin
      	q.sql.Add('  pro00_codncm         ,                ');
    end
    else begin
    		q.sql.Add('  null as pro00_codncm ,                ');
    end;

    q.sql.Add('      ntf01_itmpcopmc   ,                   ');
    q.sql.Add('      ntf01_itmproitm   ,                   ');
    q.sql.Add('      ntf01_itmproqtd   ,                   ');
    q.sql.Add('      ntf01_itmpropco   ,                   ');
    q.sql.Add('      ntf01_itmprottl   ,                   ');
    q.sql.Add('      ntf01_itmsittri   ,                   ');
    q.sql.Add('      ntf01_itmcodfis   ,                   ');
    q.sql.Add('      ntf01_itmpericm   ,                   ');
    q.sql.Add('      ntf01_itmproicm   ,                   ');
    q.sql.Add('      ntf01_itmcodcfo   ,                   ');
    q.sql.Add('      ntf01_itmrbcper   ,                   ');
    q.sql.Add('      ntf01_itmrbcvlr   ,                   ');
    q.sql.Add('      ntf01_itmicmsubbas,                   ');
    q.sql.Add('      ntf01_itmicmsubtot,                   ');

    if TMetaData.ObjExists('estnotfis01','ntf01_itmicmsubper') then
    begin
    		q.sql.Add('      ntf01_itmicmsubper               ,                   ');
    end
    else
    begin
      	q.sql.Add('      0 as ntf01_itmicmsubper          ,                   ');
    end;

    if TMetaData.ObjExists('estnotfis01','ntf01_itmicmbas') then
    begin
        //na "embale" e "info.mania" o valor de redução (ntf01_itmrbcvlr) esta incluso na BC
        if(Self.catalog=Tcatalog_table.catalog_em)or(Self.catalog=Tcatalog_table.catalog_if) then
        begin
            q.sql.Add(' ntf01_itmicmbas -ntf01_itmrbcvlr as ntf01_itmicmbas,  ');
        end
        // Para os outros clientes a base ja está reduzida
        else begin
    		    q.sql.Add(' ntf01_itmicmbas ,                                     ');
        end;
    end
    else
    begin
      	q.sql.Add('   ntf01_itmprottl -ntf01_itmrbcvlr as ntf01_itmicmbas,    ');
    end;

    if TMetaData.ObjExists('estnotfis01','ntf01_itmvlrdsp') then
    begin
    		q.sql.Add('   ntf01_itmvlrdsp  ,                                      ');
    end
    else
    begin
      	q.sql.Add('   0 as ntf01_itmvlrdsp  ,                                 ');
    end;

    if TMetaData.ObjExists('estnotfis01','ntf01_itmfrevlr') then
    begin
    		q.sql.Add('   ntf01_itmfrevlr as ntf01_itmvlrfre  ,                   ');
    end
    else
    begin
      	q.sql.Add('   0 as ntf01_itmvlrfre  ,                                 ');
    end;

    // 04.02.2012 - o campo desconto na invicta e´ "ntf01_itmvlrdesco" não sei o pq
    if Self.catalog=Tcatalog_table.catalog_df then
    begin
        q.sql.Add('   ntf01_itmvlrdesco as ntf01_itmvlrdes  , ');
    end
    else
    begin
        if TMetaData.ObjExists('estnotfis01','ntf01_itmvlrdes') then
        begin
            q.sql.Add('   ntf01_itmvlrdes  ,         ');
        end
        else
        begin
            q.sql.Add('   0 as ntf01_itmvlrdes  ,    ');
        end;
    end;

    q.sql.Add('      ntf01_itmperipi                      ,                   ');
    q.sql.Add('      ntf01_itmproipi                      ,                   ');

    if TMetaData.ObjExists('estnotfis01','ntf01_itmicmszerbs') then
    begin
    		q.sql.Add('      ntf01_itmicmszerbs                                   ');
    end
    else
    begin
      	q.sql.Add('      null as ntf01_itmicmszerbs                           ');
    end;

    q.sql.Add('from estnotfis01 	(nolock)                                    ');
    q.sql.Add('inner join cadpro00(nolock) on pro00_codigo = ntf01_itmprocod	');
    q.sql.Add('where	ntf01_codfil=%d                                         ',[Self.ntf00_codfil]);
    q.sql.Add('and 		ntf01_codntf=%d	                                        ',[Self.ntf00_codntf]);
    q.sql.Add('and 		ntf01_codtyp=%d	                                        ',[Self.ntf00_codtyp]);
    q.sql.Add('order by ntf01_itmproitm                                       ');

    q.Open;

    Result := q.IsNotEmpty;

    fpro00_codigo           :=q.Field('pro00_codigo      ');
    fpro00_codbar           :=q.Field('pro00_codbar      ');
    fpro00_descri           :=q.Field('pro00_descri      ');
    fpro00_unidad           :=q.Field('pro00_unidad      ');
    fpro00_clsfis           :=q.Field('pro00_clsfis      ');
    fpro00_indfrac          :=q.Field('pro00_indfrac     ');
    fpro00_deflotfab        :=q.Field('pro00_deflotfab   ');
    fpro00_codncm           :=q.Field('pro00_codncm      ');

    fntf01_itmproitm        :=q.Field('ntf01_itmproitm   ');
    fntf01_itmproqtd        :=q.Field('ntf01_itmproqtd   ');
    fntf01_itmpropco        :=q.Field('ntf01_itmpropco   ');
    fntf01_itmprottl        :=q.Field('ntf01_itmprottl   ');
    fntf01_itmsittri        :=q.Field('ntf01_itmsittri   ');
    fntf01_itmcodfis        :=q.Field('ntf01_itmcodfis   ');
    fntf01_itmpericm        :=q.Field('ntf01_itmpericm   ');
    fntf01_itmproicm        :=q.Field('ntf01_itmproicm   ');
    fntf01_itmcodcfo				:=q.Field('ntf01_itmcodcfo   ');
    fntf01_itmrbcper        :=q.Field('ntf01_itmrbcper   ');
    fntf01_itmrbcvlr        :=q.Field('ntf01_itmrbcvlr   ');
    fntf01_itmicmsubbas     :=q.Field('ntf01_itmicmsubbas');
    fntf01_itmicmsubtot     :=q.Field('ntf01_itmicmsubtot');
    fntf01_itmicmsubper     :=q.Field('ntf01_itmicmsubper');

    fntf01_itmperipi        :=q.Field('ntf01_itmperipi   ');
    fntf01_itmproipi        :=q.Field('ntf01_itmproipi   ');
    fntf01_itmicmszerbs     :=q.Field('ntf01_itmicmszerbs');
    fntf01_itmpcopmc     		:=q.Field('ntf01_itmpcopmc   ');

    fntf01_itmvlrdes     		:=q.Field('ntf01_itmvlrdes');
    fntf01_itmvlrdsp     		:=q.Field('ntf01_itmvlrdsp');
    fntf01_itmvlrfre     		:=q.Field('ntf01_itmvlrfre');
    fntf01_itmicmbas        :=q.Field('ntf01_itmicmbas');

    fntf01_pronumlotfab	:=q.Field('ntf01_pronumlotfab ');
    fntf01_prodatlotfab	:=q.Field('ntf01_prodatlotfab ');
    fntf01_prodatlotven	:=q.Field('ntf01_prodatlotven ');

    //
    vol :=Self.mov00_fatqtdvol=0;

    while not q.Eof do
    begin

        n1 :=Self.IndexOf(fntf01_itmproitm.AsInteger);
        if n1 = nil then
        begin
            n1 :=Self.CreateNew;
            n1.ntf01_itmproitm     :=fntf01_itmproitm.AsInteger ;
            n1.ntf01_itmproqtd     :=fntf01_itmproqtd.AsPureFloat   ;
            n1.ntf01_itmpropco     :=fntf01_itmpropco.AsPureFloat   ;
            n1.ntf01_itmprottl     :=fntf01_itmprottl.AsCurrency;
            if Tnfeutil.IsEmpty(fntf01_itmsittri.AsString) then
            begin
              n1.ntf01_itmsittri :=-1
            end
            else begin
              n1.ntf01_itmsittri  :=fntf01_itmsittri.AsInteger    ;
            end;
            n1.ntf01_itmcodfis    :=fntf01_itmcodfis.AsInteger    ;
            n1.ntf01_itmpericm    :=fntf01_itmpericm.AsCurrency   ;
            n1.ntf01_itmproicm    :=fntf01_itmproicm.AsCurrency   ;
            n1.ntf01_itmcodcfo    :=fntf01_itmcodcfo.AsInteger    ;
            n1.ntf01_itmrbcper    :=fntf01_itmrbcper.AsCurrency   ;
            n1.ntf01_itmrbcvlr    :=fntf01_itmrbcvlr.AsCurrency   ;
            n1.ntf01_itmicmsubbas :=fntf01_itmicmsubbas.AsCurrency;
            n1.ntf01_itmicmsubtot :=fntf01_itmicmsubtot.AsCurrency;
            n1.ntf01_itmicmsubper :=fntf01_itmicmsubper.AsCurrency;
            n1.ntf01_itmperipi    :=fntf01_itmperipi.AsCurrency   ;
            n1.ntf01_itmproipi    :=fntf01_itmproipi.AsCurrency   ;
            n1.ntf01_itmicmszerbs :=LowerCase(fntf01_itmicmszerbs.AsString)='t';
            n1.ntf01_itmpcopmc		:=fntf01_itmpcopmc.AsCurrency;

            n1.ntf01_itmvlrdes :=fntf01_itmvlrdes.AsCurrency	;
            n1.ntf01_itmvlrdsp :=fntf01_itmvlrdsp.AsCurrency	;
            n1.ntf01_itmvlrfre :=fntf01_itmvlrfre.AsCurrency	;
            n1.ntf01_itmicmbas :=fntf01_itmicmbas.AsCurrency  ;

            n1.ntf01_pronumlotfab	:=fntf01_pronumlotfab.AsString	;

            if fntf01_prodatlotfab.AsDateTime>0 then
            begin
                n1.ntf01_prodatlotfab	:=Trunc(fntf01_prodatlotfab.AsDateTime)	;
                n1.ntf01_prodatlotven	:=Trunc(fntf01_prodatlotven.AsDateTime)	;
            end;

            n1.pro00_codigo   :=fpro00_codigo.AsInteger;
            n1.pro00_codbar   :=fpro00_codbar.AsString;
            n1.pro00_descri   :=fpro00_descri.AsString;
            n1.pro00_unidad   :=fpro00_unidad.AsString ;
            n1.pro00_clsfis   :=fpro00_clsfis.AsInteger;
            n1.pro00_indfrac  :=LowerCase(fpro00_indfrac.AsString)='t'   ;
            n1.pro00_deflotfab:=LowerCase(fpro00_deflotfab.AsString)='t' ;
            n1.pro00_codncm   :=Copy(fpro00_codncm.AsString,1,8);

            LoadOpt(n1.pro00_codigo);

            if vol then
            begin
                Self.mov00_fatqtdvol  :=Self.mov00_fatqtdvol + Trunc(n1.ntf01_itmproqtd);
            end ;

            //consolidação do ICMS por classe-fiscal e aliquota
            cf :=festtipfis01List.IndexOf(n1.ntf01_itmcodfis, n1.ntf01_itmpericm);
            if cf = nil then
            begin
                cf :=festtipfis01List.AddNew;
                cf.codfis     :=n1.ntf01_itmcodfis;
                cf.aliq_icms  :=n1.ntf01_itmpericm;
                cf.vlr_bc_icms:=n1.ntf01_itmicmbas ;
                cf.vlr_icms   :=n1.ntf01_itmproicm ;
                cf.vlr_tot    :=n1.ntf01_itmprottl ;
            end
            else begin
                cf.vlr_bc_icms :=cf.vlr_bc_icms +n1.ntf01_itmicmbas ;
                cf.vlr_icms    :=cf.vlr_icms    +n1.ntf01_itmproicm ;
                cf.vlr_tot     :=cf.vlr_tot			+fntf01_itmprottl.AsCurrency;
            end;
            //
        end;

        q.Next;
    end;
    q.Close;
    q.Destroy;
end;

constructor Testnfelot00List.Testnfelot00.Testnotfis00.Create;
begin
  inherited Create;
  ffinrecdup00List  :=Tfinrecdup00List.Create;
  festtipfis01List  :=Testtipfis01List.Create;
  fNFe              :=TNFe.Create();
  finfProt          :=TinfProt.Create;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.CreateNew: Testnotfis01;
begin
  Result         :=Testnotfis01.Create;
  Result.CParent :=Self;
  Result.Index   :=Self.Count;
  inherited Add(Result);
end;

destructor Testnfelot00List.Testnfelot00.Testnotfis00.Destroy;
begin
  ffinrecdup00List.Destroy;
  festtipfis01List.Destroy;
  fNFe.Destroy;
  finfProt.Destroy;
  inherited Destroy;
end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoFillXML;
var n1:Testnfelot00List.Testnfelot00.Testnotfis00.Testnotfis01;
var d0:Tfinrecdup00List.Tfinrecdup00;

var det :TnfeDet;
var pro :TnfeProduto; // Tprod;
var imp :TnfeImposto; // Timposto;
var dup :TdupList.Tdup;
var cls :Testtipfis01;

var fpg :TnfePgto;

var I,P:Integer;
var S:string;

var vBC: Currency ;
var pICMS: Currency ;
var vICMS: Currency ;
var vBCST: Currency;
var pICMSST: Currency;
var vICMSST: Currency;
var pRedBC: Currency ;
var vDesc: Currency ;

var yy,mm,dd,hh,nn,ss,ms: Word;

var infCpl: string;
var codbar:Integer;
//    codbar:Int64;
begin

    if(Self.ntf00_nfestt in[TNFe.COD_AUT_USO_NFE, TNFe.COD_REJ_DUPLI_NFE])or
      (Self.ntf00_nfestt =TNFe.COD_DON_ENVIO) then
//     ((Self.ntf00_nfestt =TNFe.COD_DON_ENVIO)and(Self.ntf00_nfeemi in[emisCon_FS,emisCon_FSDA]))then
    begin
        Self.fNFe.XML	:=Self.ntf00_nfexml;

        // infProt autorização
        if Self.ntf00_nfestt=TNFe.COD_AUT_USO_NFE then
        begin
            finfProt.tpAmp    :=Self.ntf00_nfeamb;
            finfProt.verAplic :=Self.CParent.lot00_comapp;
            finfProt.chNFe    :=Self.ntf00_nfekey;
            finfProt.dhRecbto :=Self.ntf00_nfedhrecbto;
            finfProt.nProt    :=Self.ntf00_nferetcon;
            finfProt.digVal   :=Self.ntf00_nfedigval;
            finfProt.cStat    :=Self.ntf00_nfestt;
            finfProt.xMotivo  :=Self.ntf00_nfemot;
        end;
        Exit;
    end;

    DecodeDateTime(ntf00_rem_dat_sai,yy,mm,dd,hh,nn,ss,ms);

    fNFe.Clear;

    // ide
    fNFe.ide.cUF               :=fil00_ufcod;
    fNFe.ide.cNF               :=ntf00_codntf;
    fNFe.ide.natOp             :=cfop00_descri;
    fNFe.ide.cMod              :=ntf00_nfemod;  //TNFe.MOD_55;
    fNFe.ide.serie             :=ntf00_nfeser;
    fNFe.ide.nNF               :=ntf00_rem_ntf_fis;
    fNFe.ide.tpNF              :=TnfeTypDoc(ntf00_codtyp);
    fNFe.ide.idDest            :=ntf00_nfeiddest ;
    fNFe.ide.dEmi              :=ntf00_rem_dat_emi;
    fNFe.ide.dSaiEnt           :=EncodeDate(yy,mm,dd) ;
    fNFe.ide.hSaiEnt           :=EncodeTime(hh,nn,ss,000) ;
    fNFe.ide.cMunFG            :=fil00_codibge;
    fNFe.ide.tpImp             :=ntf00_nfetpimp;
    fNFe.ide.tpEmis            :=ntf00_nfeemi;
    fNFe.ide.tpAmb             :=ntf00_nfeamb;
    fNFe.ide.finNFe            :=finNormal;
    fNFe.ide.indFinal          :=ntf00_nfeindfinal;
    fNFe.ide.indPres           :=ntf00_nfeindpres;
    fNFe.ide.dhCont						 :=LocalConfigNFe.conting.DataHora; //CParent.fconfigNFe.justCont.DataHora	;
    fNFe.ide.xJust						 :=LocalConfigNFe.conting.Justifica;// CParent.fconfigNFe.justCont.Justifica;

    // emit
//    if fNFe.ide.tpAmb=ambPro then
//    begin
//        fNFe.emit.CNPJ :=fil00_cgc;
//        fNFe.emit.IE   :=fil00_insest;
//    end
//    else begin
//        fNFe.emit.CNPJ:=LocalConfigNFe.emit.CNPJ;
//        fNFe.emit.IE  :=LocalConfigNFe.emit.IE;
//    end;
    fNFe.emit.CNPJ :=fil00_cgc;
    fNFe.emit.IE   :=fil00_insest;

    fNFe.emit.xNome            :=fil00_descri;
    fNFe.emit.ender.xLgr   :=fil00_logr;
    fNFe.emit.ender.nro    :=fil00_nlogr;
    fNFe.emit.ender.xBairro:=fil00_bairro;
    fNFe.emit.ender.cMun   :=fil00_codibge;
    fNFe.emit.ender.xMun   :=fil00_mun;
    fNFe.emit.ender.UF     :=fil00_uf;
    fNFe.emit.ender.CEP    :=fil00_cep ;
    fNFe.emit.ender.fone   :=fil00_ddd + fil00_fone;
    fNFe.emit.CRT							 :=3 ;

    // dest
    case Self.cli00_typpes of
        ccFIS: fNFe.dest.CPF :=cli00_ciccgc;
        ccJUR,ccRUD: fNFe.dest.CNPJ :=cli00_ciccgc;
    else
        fNFe.dest.CPF :='';
        fNFe.dest.CNPJ:='';
    end;
    fNFe.dest.xNome            :=cli00_rzsoci;
    fNFe.dest.ender.xLgr   :=cli00_logr;
    fNFe.dest.ender.nro    :=cli00_nlogr;
    fNFe.dest.ender.xBairro:=cli00_bairro;
    fNFe.dest.ender.cMun   :=cli00_codibge;
    fNFe.dest.ender.xMun   :=cli00_mun;
    fNFe.dest.ender.UF     :=cli00_uf;
    fNFe.dest.ender.CEP    :=cli00_cep ;
    fNFe.dest.ender.fone   :=cli00_ddd + cli00_fone;
//    fNFe.dest.enderDest.codcid :=cli00_codcid;
    fNFe.dest.IE               :=cli00_rginsc;
    fNFe.dest.email            :=cli00_emaildanfe;
    fNFe.dest.cod_dest      :=cli00_codigo ;

    Self.CLoadItems;

    vDesc:=0  ;

    // det
    for i :=0 to Self.Count -1 do
    begin
        n1 :=Self.Items[i];
        if n1<>nil then
        begin

            // Produtos
            det :=fNFe.det.Add	;
            pro :=det.prod;
            imp :=det.imposto;

            pro.cProd	:=IntToStr(n1.pro00_codigo);
            //codbar :=StrToIntDef(n1.pro00_codbar,0);
            //if codbar>9999999 then
            if Tnfeutil.EAN13Valido(n1.pro00_codbar) then
            begin
                pro.cEAN :=n1.pro00_codbar;
            end
            else
            begin
              	pro.cEAN :='';
            end;

            pro.xProd         :=n1.pro00_descri;
            // pro.NCM	:=Tnfeutil.SeSenao(n1.pro00_codncm<>'',n1.pro00_codncm,'98')	;
            if(n1.pro00_codncm='')or(n1.pro00_codncm='0') then
            begin
                pro.NCM	 :='98';
            end
            else
            begin
                pro.NCM	:=n1.pro00_codncm;
            end;

            pro.CFOP    :=n1.ntf01_itmcodcfo;
            pro.uCom    :=n1.pro00_unidad;
            pro.qCom    :=n1.ntf01_itmproqtd;
            pro.vUnCom  :=n1.ntf01_itmpropco;
            pro.vProd   :=n1.ntf01_itmproqtd * n1.ntf01_itmpropco; //n1.ntf01_itmprottl;
            pro.cEANTrib:=pro.cEAN;
            pro.uTrib   :=pro.uCom;
            pro.qTrib   :=pro.qCom;
            pro.vUnTrib :=pro.vUnCom;
            pro.vFrete	:=n1.ntf01_itmvlrfre	;
            pro.vSeg		:=0.00	;
            pro.vDesc		:=n1.ntf01_itmvlrdes	;
            pro.vOutro	:=n1.ntf01_itmvlrdsp	;
            pro.indTot	:=1;

            vDesc :=vDesc+ pro.vDesc ;

            // medicamentos
            if n1.pro00_deflotfab then
            begin
                pro.med.nLote	:=n1.ntf01_pronumlotfab;
                pro.med.qLote	:=n1.ntf01_itmproqtd ;
                pro.med.dFab	:=n1.ntf01_prodatlotfab;
                pro.med.dVal	:=n1.ntf01_prodatlotven;
                pro.med.vPMC	:=n1.ntf01_itmpcopmc	;
            end;

            // info ad
            // pro.infAdProd			:=Format('CLASSE FISCAL %.2d',[n1.pro00_clsfis]);

            // colunas não oficiais
//            pro.cCF           :=Tnfeutil.FInt(n1.pro00_clsfis,2);
//            pro.indFrac				:=n1.pro00_indfrac	;

            // base de calc
            vBC 	:=n1.ntf01_itmicmbas; // n1.ntf01_itmprottl -n1.ntf01_itmrbcvlr	;
            pICMS	:=n1.ntf01_itmpericm;
            vICMS	:=n1.ntf01_itmproicm;

            // 24.03.2011 - zera base (conforme o Sr. Ruy)
//            if n1.ntf01_itmicmszerbs then
//            begin
//                vBC	:=0.00	;
//            end;

            // 04.06.2011 inversão dos campos:
            // ntf01_itmicmsubtot/ntf01_itmicmsubbas (conforme o Sr. Ruy)
            vBCST		:=n1.ntf01_itmicmsubbas	; // n1.ntf01_itmicmsubtot
            pICMSST :=n1.ntf01_itmicmsubper	;
            vICMSST	:=n1.ntf01_itmicmsubtot	;	// n1.ntf01_itmicmsubbas

            // % redução de BC
            pRedBC	:=n1.ntf01_itmrbcper;

            // Imposto

            imp.vTotTrib :=0 ;
            if n1.opt00_optcod = 0 then
            begin
                imp.ICMS.orig:=oriNacional;
            end
            else begin
                if Self.mov00_codtyp<>22 then
                begin
                    if Self.fil00_codcou = Self.cli00_codcou then
                        imp.ICMS.orig:=oriEst_AdqMerInt
                    else
                        imp.ICMS.orig:=oriEst_ImportDir;
                end
                else
                    imp.ICMS.orig:=oriEst_AdqMerInt
            end;

            // *************************
            // Dados do ICMS Normal e ST
            // *************************
            case n1.ntf01_itmsittri of

              // 00 - Tributada integralmente
              00:
              begin
                imp.ICMS.CST    :=cst00;
                imp.ICMS.modBC  :=mbcVlrOperacao;
                imp.ICMS.vBC    :=vBC	;
                imp.ICMS.pICMS  :=pICMS;
                imp.ICMS.vICMS  :=vICMS;
              end;

              // 10 - Tributada e com cobrança do ICMS por substituição tributária
              10:
              begin
                imp.ICMS.CST           :=cst10;
                imp.ICMS.modBC         :=mbcMargem;
                imp.ICMS.vBC           :=vBC;
                imp.ICMS.pICMS         :=pICMS;
                imp.ICMS.vICMS         :=vICMS;
                imp.ICMS.modBCST       :=mbcstMargem;
                imp.ICMS.pMVAST        :=0;
                imp.ICMS.pRedBCST      :=0;
                imp.ICMS.vBCST         :=vBCST;
                imp.ICMS.pICMSST       :=pICMSST;
                imp.ICMS.vICMSST       :=vICMSST;
              end;

              // 20 - Com redução de base de cálculo
              20:
              begin
                imp.ICMS.CST        :=cst20;
                imp.ICMS.modBC      :=mbcMargem;
                imp.ICMS.pRedBC     :=pRedBC;
                imp.ICMS.vBC        :=vBC;
                imp.ICMS.pICMS      :=pICMS;
                imp.ICMS.vICMS      :=vICMS;
              end;

              // 30 Isenta ou não tributada e com cobrança do ICMS por
              // substituição tributária
              30:
              begin
                imp.ICMS.CST           :=cst30;
                imp.ICMS.modBCST       :=mbcstMargem;
                imp.ICMS.pMVAST        :=0;
                imp.ICMS.pRedBCST      :=0;
                imp.ICMS.vBCST         :=vBCST;
                imp.ICMS.pICMSST       :=pICMSST;
                imp.ICMS.vICMSST       :=vICMSST;
              end;

              // 40 - Isenta
              // 41 - Não tributada
              // 50 - Suspensão
              40,41,50:
              begin
                imp.ICMS.CST   :=TnfeCSTIcms(n1.ntf01_itmsittri);
              end;

              // 51 - Diferimento
              // A exigência do preenchimento das informações do ICMS diferido
              // fica à critério de cada UF.
              51:
              begin
                imp.ICMS.CST       :=cst51;
                imp.ICMS.modBC     :=mbcMargem;
                imp.ICMS.pRedBC    :=0;
                imp.ICMS.vBC       :=vBC	;
                imp.ICMS.pICMS     :=pICMS;
                imp.ICMS.vICMS     :=vICMS;
              end;

              // 60 - ICMS cobrado anteriormente por substituição tributária
              60:
              begin
                imp.ICMS.CST           :=cst60;
                imp.ICMS.vBCSTRet      :=vBCST		;
                imp.ICMS.vICMSSTRet    :=vICMSST	;
              end;

              // 70 - Com redução de base de cálculo e cobrança do
              // ICMS por substituição tributária
              70:
              begin
                imp.ICMS.CST           :=cst70;
                imp.ICMS.modBC         :=mbcMargem;
                imp.ICMS.pRedBC        :=0;
                imp.ICMS.vBC           :=vBC;
                imp.ICMS.pICMS         :=pICMS;
                imp.ICMS.vICMS         :=vICMS;
                imp.ICMS.modBCST       :=mbcstMargem;
                imp.ICMS.vBCST         :=vBCST;
                imp.ICMS.pICMSST       :=pICMSST;
                imp.ICMS.vICMSST       :=vICMSST;
              end;

            else // 90 - Outras
                imp.ICMS.CST           :=cst90;
            end;

            // ************
            // Dados do IPI
            // ************
            imp.IPI.cEnq    :='999';
            imp.IPI.CST     :=ipi99;
            imp.IPI.vBC     :=n1.ntf01_itmprottl;//vBC;
            imp.IPI.pIPI    :=n1.ntf01_itmperipi;
            imp.IPI.vIPI    :=n1.ntf01_itmproipi;

            // ***********
            // Dados do II
            // ***********

            // ************
            // Dados do PIS
            // ************
            imp.PIS.CST     :=pis01; // unfexml.cpAliq;
            imp.PIS.vBC     :=0;
            imp.PIS.pPIS    :=0;
            imp.PIS.vPIS    :=0;

            // ***************
            // Dados do COFINS
            // ***************
            imp.COFINS.CST     :=cof01; // unfexml.ccAliq;
            imp.COFINS.vBC     :=0;
            imp.COFINS.pCOFINS :=0;
            imp.COFINS.vCOFINS :=0;

        end;
    end;

    fNFe.total.DoReCalc();

    // transportes
    with fNFe.transp do
    begin
        if fNFe.ide.cMod = TNFe.MOD_55 then
        begin
            modFrete        :=TnfeFret(ntf00_trp_fre_tip);
            if IsCGC(ntf00_trp_cpf_cnp) then
                transporta.CNPJ :=ntf00_trp_cpf_cnp
            else
                transporta.CPF :=ntf00_trp_cpf_cnp;
            transporta.xNome:=ntf00_trp_raz_soc;
            transporta.xEnder:=ntf00_trp_endere ;
            transporta.xMun:=ntf00_trp_cidnom ;
            transporta.UF:=ntf00_trp_cid_uf ;
            veicTransp.placa:=ntf00_trp_crr_pla;
            veicTransp.UF   :=ntf00_trp_crr_uf;
            vol.qVol        :=mov00_fatqtdvol;
            vol.esp         :='VOLUME';
            vol.pesoL       :=ntf00_trp_pes_liq;
            vol.pesoB       :=ntf00_trp_pes_bru;
        end
        else begin
            modFrete        :=freDest;
            vol.qVol        :=mov00_fatqtdvol;
            vol.esp         :='VOLUME';
        end;
    end;

    // cobranca
    if Self.ffinrecdup00List.Count >0 then
    begin
        if fNFe.ide.cMod = TNFe.MOD_55 then
        begin
            fNFe.ide.indPag :=pgAPrz;
            d0  :=Self.ffinrecdup00List.Items[0];
            fNFe.cobr.fat.nFat :=d0.dup00_numfat;
            fNFe.cobr.fat.vOrig:=Self.ffinrecdup00List.Total ;
            fNFe.cobr.fat.vDesc:=vDesc;
            fNFe.cobr.fat.vLiq :=fNFe.cobr.fat.vOrig -vDesc;

            for i :=0 to Self.ffinrecdup00List.Count -1 do
            begin
                d0  :=Self.ffinrecdup00List.Items[i];
                Dup :=fNFe.cobr.dup.Add;
                Dup.nDup  :=d0.dup00_codigo;
                Dup.dVenc :=d0.dup00_datven;
                Dup.vDup  :=d0.dup00_valor;
                Dup.age_codigo :=d0.age00_codigo;
                Dup.age_descri :=d0.age00_sigla	;
            end;
        end
        else begin
            fpg :=fNFe.pag.Add ;
            fpg.tPag :=fpDinheiro ;
            fpg.vPag :=Self.ffinrecdup00List.Total ;
        end;
    end;

    //*******************
    //info complementares
    //*******************

    infCpl :=fNFe.infAdic.infCpl;


    if(fNFe.ide.dEmi >= EncodeDate(2013,5,15))and(ntf00_imp_vlrtricon > 0)then
    begin
        infCpl :='Val Aprox Tributos R$ '+Tnfeutil.FCur(ntf00_imp_vlrtricon);
        infCpl :=infCpl +' ('+Tnfeutil.FCur(ntf00_imp_alqtricon) +'%) Fonte: IBPT';
    end;

    //na ponto max a msg tem q aparecer mesmo para mov00_codtyp=22
    if Self.catalog=Tcatalog_table.catalog_pm then
    begin
        if infCpl<>'' then
          infCpl :=infCpl +';'+Self.ntf00_rem_observa
        else
          infCpl :=Self.ntf00_rem_observa;
    end;
    //
    if Self.mov00_codtyp<>22 then
    begin
        infCpl :=infCpl + StrUtils.IfThen(infCpl<>'',';'+Self.ntf00_rem_observa,Self.ntf00_rem_observa);
        if infCpl<>'' then
        begin
            if Self.ntf00_rem_fatobs00<>'' then
            begin
                infCpl :=infCpl +';'+Self.ntf00_rem_fatobs00;
            end;
        end
        else begin
            infCpl :=Self.ntf00_rem_fatobs00;
        end;
    end;

    // classe fiscal
    if (Self.CParent.fconfigNFe.danfe.msg_cf)and(festtipfis01List.Count>0) then
    begin

        festtipfis01List.PesFis :=cli00_typpes  =ccFIS;
        festtipfis01List.OpeInt :=cli00_uf      =fil00_uf;
        festtipfis01List.LoadMsg(ntf00_codfil, ntf00_codntf, ntf00_codtyp);
        P :=0; cls :=nil;

        for I :=0 to festtipfis01List.Count -1 do
        begin

            cls :=festtipfis01List.Items[I];
            S :=Tnfeutil.FInt(cls.codfis);
            //18.10.2012-add a coluna vlr_tot
            S :=S +AlignStr(10, Tnfeutil.FCur(cls.vlr_tot    ), ' ', taRightJustify) +' ';
            S :=S +AlignStr(10, Tnfeutil.FCur(cls.vlr_bc_icms), ' ', taRightJustify) +' ';
            S :=S +AlignStr(10, Tnfeutil.FFlt(cls.aliq_icms  ), ' ', taRightJustify) +' ';
            S :=S +AlignStr(10, Tnfeutil.FCur(cls.vlr_icms   ), ' ', taRightJustify);

            if infCpl<>'' then infCpl :=infCpl +';'+ S
            else               infCpl :=S;

            if(cls.msg_01<>'')or(cls.msg_02<>'')or(cls.msg_03<>'')then
            begin
                P :=I;
            end;

        end;

        cls :=festtipfis01List.Items[P];
        infCpl :=infCpl +StrUtils.IfThen(cls.msg_01<>'', ';'+cls.msg_01);
        infCpl :=infCpl +StrUtils.IfThen(cls.msg_02<>'', ';'+cls.msg_02);
        infCpl :=infCpl +StrUtils.IfThen(cls.msg_03<>'', ';'+cls.msg_03);

    end;

    // 30.05.2011 - PAF-ECF
    if Self.mov00_cuppdv>0 then
    begin
      	s :=Trim(infCpl);
        if s<>'' then
        begin
          	s :=s +';;';
        end	;

        if mov00_cupecf>0 then
        begin
            s :=s +Format('ECF: %.3d   PDV: %.3d',[mov00_cupecf,mov00_cuppdv]);
        end
        else begin
          	s :=s +Format('PDV: %.3d',[mov00_cuppdv]);
        end;

        if mov00_cupcod>0 then
        begin
          	s :=s +Format('   CCF: %.6d',[mov00_cupcod]);
        end;

        if mov00_cupcoo>0 then
        begin
          	s :=s +Format('   COO: %.6d',[mov00_cupcoo]);
        end;

        if mov00_cuppreven>0 then
        begin
          	s :=s +Format('   PRE-VENDA:PV%.10d',[mov00_cuppreven]);
        end;

        infCpl:=s;
    end;
    fNFe.infAdic.infCpl:=infCpl;
    //***************************
    //fim das info complementares
    //***************************
end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoPrintDANFE(
  const Destino: Byte; const Impressora: string;
  const Copias: Integer);
//var
//  danfe: TDANFeRetrato;
begin

{    DoFillXML;

    danfe :=TDANFeRetrato.Create(Self.NFe, Self.infProt);
    try
        danfe.BlcCab.Logotipo :=LocalConfigNFe.emit.logo;
        case Destino of
            1: danfe.RenderToPrinter(Impressora, Copias) ;
            2: danfe.RenderToPDF(LocalConfigNFe.danfe.local) ;
        else
            danfe.DoExecute(rdPreview) ;
        end;
    finally
        danfe.Free;
    end;
}
end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoRegisterCopyNFe(
  const ACopy: Boolean);
var
  q:TQueryDBZ;
begin
    if not Self.ntf00_nfecopy and TMetaData.ObjExists('estnotfis00','ntf00_nfecopy') then
    begin
      q :=NewQueryDBZ(CDataBase);
      q.sql.add('update estnotfis00 set ntf00_nfecopy=%d',[Ord(ACopy)]);
      q.sql.add('where ntf00_codfil=%d                  ',[Self.ntf00_codfil]);
      q.sql.add('and   ntf00_codtyp=%d                  ',[Self.ntf00_codtyp]);
      q.sql.add('and   ntf00_codntf=%d                  ',[Self.ntf00_codntf]);
      q.ExecSQL;
      q.Destroy;
    end;
end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoRegisterInfCancNFe(
                                                  const can00_versao: string   ;
                                                  const can00_ideamb: TnfeAmb  ;
                                                  const can00_verapp: string   ;
                                                  const can00_codstt: Integer  ;
                                                  const can00_motstt: string   ;
                                                  const can00_codest: Integer  ;
                                                  const can00_chnfe : string   ;
                                                  const can00_dhrec : TDateTime;
                                                  const can00_nprot : string  ;
                                                  const can00_justcanc: string);
var q:TQueryDBZ;
begin
    //
    q :=NewQueryDBZ(CDataBase);
    q.SQL.Add('declare @retCod  		int         ;set @retCod = 0               ');
    q.SQL.Add('declare @can00_chnfe	varchar(44) ;set @can00_chnfe =:can00_chnfe');
    q.SQL.Add('                                                                ');
    q.SQL.Add('begin tran                                                      ');
    q.SQL.Add('begin try                                                       ');
    q.SQL.Add('                                                                ');
    q.sql.add('   if not exists(select can00_chnfe from estnfecanc00(nolock)   ');
    q.sql.add('   							where can00_chnfe=@can00_chnfe)								 ');
    q.sql.add('   begin                                                        ');
    q.sql.add('       insert into estnfecanc00	(can00_chnfe	)                ');
    q.sql.add('       values 										(@can00_chnfe	)                ');
    q.sql.add('   end  ;                                                       ');

    q.sql.add('   update estnfecanc00 set   can00_versao   =:can00_versao      ');
    q.sql.add('                           , can00_ideamb   =:can00_ideamb      ');
    q.sql.add('                           , can00_verapp   =:can00_verapp      ');
    q.sql.add('                           , can00_codstt   =:can00_codstt      ');
    q.sql.add('                           , can00_codest   =:can00_codest      ');
    q.sql.add('                           , can00_dhrec    =:can00_dhrec       ');
    q.sql.add('                           , can00_nprot    =:can00_nprot       ');
    if can00_justcanc<>'' then
    begin
    		q.sql.add('                       , can00_justcanc =:can00_justcanc    ');
    end;
    q.sql.add('   where can00_chnfe = @can00_chnfe ;                           ');

    q.SQL.Add('   update estnotfis00 set                                       ');
    q.sql.add('      ntf00_nfestt    =:ntf00_nfestt                            ');
    q.sql.add('     ,ntf00_nfemot    =:ntf00_nfemot                            ');
    q.sql.add('     ,ntf00_ntfcan    =''t''                                    ');
    q.SQL.Add('   where ntf00_codfil = :ntf00_codfil                           ');
    q.SQL.Add('   and   ntf00_codtyp = :ntf00_codtyp                           ');
    q.SQL.Add('   and   ntf00_codntf = :ntf00_codntf ;                         ');
    q.SQL.Add('                                                                ');
    q.SQL.Add('end try                                                         ');
    q.sql.Add('begin catch                                                     ');
    q.sql.Add('		if @@trancount > 0  rollback tran                            ');
    q.sql.Add('end catch ;                                                     ');
    q.sql.Add('if @@trancount > 0 commit tran ;                                ');
    //
    q.Param('can00_chnfe ').AsString  :=can00_chnfe;
    q.Param('can00_versao').AsString  :=can00_versao;
    q.Param('can00_ideamb').AsInteger :=Ord(can00_ideamb);
    q.Param('can00_verapp').AsString  :=can00_verapp;
    q.Param('can00_codstt').AsInteger :=can00_codstt;
    q.Param('can00_codest').AsInteger :=can00_codest;
    q.Param('can00_dhrec ').AsDateTime:=can00_dhrec;
    q.Param('can00_nprot ').AsString  :=can00_nprot;
    if can00_justcanc<>'' then
    begin
    		q.Param('can00_justcanc').AsString :=can00_justcanc;
    end;
    //
    q.Param('ntf00_nfestt').AsInteger :=can00_codstt;
    q.Param('ntf00_nfemot').AsString  :=can00_motstt;
//    q.Param('ntf00_ntfcan').AsString  :='t';
    q.Param('ntf00_codfil').AsInteger :=Self.ntf00_codfil;
    q.Param('ntf00_codtyp').AsInteger :=Self.ntf00_codtyp;
    q.Param('ntf00_codntf').AsInteger :=Self.ntf00_codntf;
    //
    q.ExecSQL	;
    //
    q.Destroy;
end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoRegisterSitNFe(
                                          const codstt :Integer;
                                          const motstt :string ;
                                          const nprot  :string ;
                                          const dhrecbto:TDateTime;
                                          const digval  :string;
                                          const verapp: string);
var q:TQueryDBZ;
begin
    Self.ntf00_nfestt :=codstt ;
    q:=NewQueryDBZ(CDataBase);
    q.sql.Add('update estnotfis00 set               ');
    q.sql.add('   ntf00_nfestt   = :ntf00_nfestt    ');
    q.Param('ntf00_nfestt').AsInteger :=codstt;

    if codstt in[TNFe.COD_DON_ENVIO,TNFe.COD_REJ_XML_MAU_FORMADO,TNFe.COD_REJ_FALHA_SCHEMA_XML] then
    begin
      	q.sql.add('		,ntf00_nfekey =:ntf00_nfekey   ');
        q.sql.add('		,ntf00_nfexml =:ntf00_nfexml   ');
        q.sql.add('		,ntf00_nfemot   =:ntf00_nfemot ');
        q.Param('ntf00_nfekey').AsString	:=Self.NFe.Id	;
        q.Param('ntf00_nfexml').AsMemo		:=Self.NFe.XML;
        // com reijeição xml mau formado ou generalizada!
        if codstt in[TNFe.COD_REJ_XML_MAU_FORMADO,TNFe.COD_REJ_FALHA_SCHEMA_XML] then
        begin
        		q.Param('ntf00_nfemot').AsString  :=Copy(Tnfeutil.RemoveCtrlChar(motstt),1,250);
        end
        // Valida e pronto p/ envio
        else begin
    				q.Param('ntf00_nfemot').AsString  :=motstt;
        end;
    end
    // Autorizacao de Uso / Uso Denegado /
    else if codstt in[TNFe.COD_AUT_USO_NFE,TNFe.COD_DEN_USO_NFE] then
    begin
        q.sql.add('   ,ntf00_nferetcon  = :ntf00_nferetcon  ');
        q.sql.add('   ,ntf00_nfedhrecbto= :ntf00_nfedhrecbto');
        q.sql.add('   ,ntf00_nfedigval  = :ntf00_nfedigval  ');
				q.sql.add('		,ntf00_nfemot     = :ntf00_nfemot     ');
        q.sql.add('		,ntf00_nfeverapp  = :ntf00_nfeverapp  ');
        q.Param('ntf00_nferetcon  ').AsString   :=nprot;
        q.Param('ntf00_nfedhrecbto').AsDateTime :=dhrecbto;
        q.Param('ntf00_nfedigval  ').AsString   :=digval;
        q.Param('ntf00_nfemot     ').AsString		:=motstt;
        q.Param('ntf00_nfeverapp  ').AsString		:=verapp;
        Self.ntf00_nferetcon  :=nprot;
        Self.ntf00_nfedhrecbto:=dhrecbto;
        Self.ntf00_nfedigval  :=digval ;
        Self.ntf00_nfemot     :=motstt ;
    end
    else begin
				q.sql.add('  ,ntf00_nfemot   = :ntf00_nfemot    ');
    		q.Param('ntf00_nfemot').AsString  :=motstt;
    end;
    q.sql.add('where ntf00_codfil   = :ntf00_codfil           ');
    q.sql.add('and   ntf00_codtyp   = :ntf00_codtyp           ');
    q.sql.add('and   ntf00_codntf   = :ntf00_codntf           ');
    q.Param('ntf00_codfil').AsInteger :=Self.ntf00_codfil;
    q.Param('ntf00_codtyp').AsInteger :=Self.ntf00_codtyp;
    q.Param('ntf00_codntf').AsInteger :=Self.ntf00_codntf;
    //
    q.ExecSQL;
    q.Destroy;

end;

procedure Testnfelot00List.Testnfelot00.Testnotfis00.DoRemove;
var Q:TQueryDBZ;
begin
    Q:=NewQueryDBZ(CDataBase);
    Q.sql.add('declare @ntf00_nfelot int ; set @ntf00_nfelot = %d',[Self.CParent.lot00_codlot]) ;
    Q.sql.add('update estnotfis00 set                            ');
    Q.sql.add('     ntf00_nfelot=00                              ');
    Q.sql.add('     ,ntf00_nfekey=null                           ');
    Q.sql.add('     ,ntf00_nfestt=null                           ');
    Q.sql.add('     ,ntf00_nfeemi=null                           ');
    Q.sql.add('     ,ntf00_nfexml=null                           ');
    Q.sql.add('     ,ntf00_nfemot=null                           ');
    Q.sql.add('where ntf00_codfil=%d                             ',[ntf00_codfil ]);
    Q.sql.add('and   ntf00_codtyp=%d                             ',[ntf00_codtyp ]);
    Q.sql.add('and   ntf00_codntf=%d                             ',[ntf00_codntf ]);
    Q.ExecSQL;
    Q.Destroy;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.Get(
  Index: Integer): Testnotfis01;
begin
    Result := inherited Items[index];
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.GetXml(
  const ALayout: TLayOut): string;
var nfe:TNativeXml;
var xml:TNativeXml;
var p:TXmlNode;
begin

    case ALayout of
        LayNfe:
        begin
            Result :=Self.ntf00_nfexml;
        end;

        LayNfeCancelamento:
        begin
            xml :=TNativeXml.CreateName('procCancNFe');
            try
                xml.XmlFormat :=xfCompact;

                p :=xml.Root;
                p.AttributeAdd('xmlns' ,  URL_PORTALFISCAL_INF_BR_NFE);
                p.AttributeAdd('versao',  NFE_VER_PROC_CANC_NFE );

                p :=p.NodeNew('protNFe');
                p.AttributeAdd('versao',	NFE_VER_NFE);
                p :=p.NodeNew('infProt');

                p.WriteInteger  ('tpAmb'    , Tnfeutil.SeSenao(Self.ntf00_nfeamb=ambPro,1,2));
                p.WriteString   ('verAplic' , CParent.lot00_comapp     );
                p.WriteString   ('chNFe'    , Self.ntf00_nfekey        );
                p.WriteDateTime ('dhRecbto' , Self.ntf00_nfedhrecbto   );
                p.WriteString   ('nProt'    , Self.ntf00_nferetcon     );

                if not Tnfeutil.IsEmpty(Self.ntf00_nfedigval) then
                begin
                    p.WriteString('digVal', Self.ntf00_nfedigval);
                end;

                p.WriteInteger  ('cStat'    , Self.ntf00_nfestt        );
                p.WriteString   ('xMotivo'  , Self.ntf00_nfemot        );

                Result :=xml.WriteToString;

            finally
                xml.Free;
            end;
        end;

        LayNfeProc:
        begin
            nfe	:=TNativeXml.Create;
            xml	:=TNativeXml.CreateName('nfeProc');
            try
                xml.XmlFormat     :=xfCompact;
                xml.VersionString :='1.0';
                xml.Charset :='UTF-8';

                nfe.ReadFromString(Self.ntf00_nfexml);

                p :=xml.Root;
                p.AttributeAdd('xmlns' ,  URL_PORTALFISCAL_INF_BR_NFE);
                p.AttributeAdd('versao',  NFE_VER_NFE_PROC  );
                p.NodeAdd(nfe.Root);

                p :=p.NodeNew('protNFe');
                p.AttributeAdd('versao',	NFE_VER_NFE);
                p :=p.NodeNew('infProt');
                p.WriteInteger  ('tpAmb'    , Tnfeutil.SeSenao(Self.ntf00_nfeamb=ambPro,1,2));
                p.WriteString   ('verAplic' , CParent.lot00_comapp     );
                p.WriteString   ('chNFe'    , Self.ntf00_nfekey        );
                p.WriteDateTime ('dhRecbto' , Self.ntf00_nfedhrecbto   );
                p.WriteString   ('nProt'    , Self.ntf00_nferetcon     );

                if not Tnfeutil.IsEmpty(Self.ntf00_nfedigval) then
                begin
                  p.WriteString('digVal', Self.ntf00_nfedigval);
                end;

                p.WriteInteger  ('cStat'    , Self.ntf00_nfestt        );
                p.WriteString   ('xMotivo'  , Self.ntf00_nfemot        );

                Result :=xml.WriteToString;

            finally
                xml.Free;
            end;
        end;
    end;

end;

function Testnfelot00List.Testnfelot00.Testnotfis00.IndexOf(
  ntf01_itmproitm: Integer): Testnotfis01;
var i:Integer;
begin
    Result:=nil;
    for i:=0 to Self.Count -1 do
    begin
        if Self.Items[i].ntf01_itmproitm = ntf01_itmproitm then
        begin
             Result :=Self.Items[i];
             Break;
        end;
    end;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.PrintDANFE(const outDanfe: TOutiputDanfe;
    const outDevive: string;
    const outCopies: Integer;
    var FileName: string;
    var retMsg: string): Boolean;
var
  D: TnfeDanfe;
begin

    DoFillXML;

    D :=TnfeDanfe.Create(Self.NFe, outDanfe, Self.infProt);
    try
        if FileName <> '' then
        begin
            D.OutputFileName :=FileName;
        end;
        D.DeviceName  :=outDevive;
        D.Copies      :=outCopies;
        D.Logo        :=LocalConfigNFe.emit.logo; //  Self.CParent.fconfigNFe.emit.logo;
        D.Execute;
    finally
        FileName:=D.OutputFileName;
        retMsg  :=D.AbortMsg ;
        Result  :=not D.Aborted;
        D.Free;
    end;


end;

function Testnfelot00List.Testnfelot00.Testnotfis00.registerXML(xml: string): Boolean;
var Q:TQueryDBZ;
begin
     Q :=NewQueryDBZ(CDataBase);

     Q.sql.add('update estnotfis00 set        ');
     Q.sql.add('       ntf00_nfexml=:xml      ');
     Q.sql.add('where ntf00_codfil=%d         ',[Self.ntf00_codfil]);
     Q.sql.add('and   ntf00_codtyp=%d         ',[Self.ntf00_codtyp]);
     Q.sql.add('and   ntf00_codntf=%d         ',[Self.ntf00_codntf]);

     Q.Param('xml').AsMemo  :=xml;

     Q.ExecSQL;
     Q.Destroy;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.SaveXmlToFile(
	const ALayout:TLayOut;
  const ALocal: string): Boolean;
var xml:String;
var yy,mm,dd:Word;
var f:String;
begin
    Result :=False;

    xml :=Self.GetXml(ALayout);
		if xml<>'' then
    begin
        DecodeDate(Self.ntf00_rem_dat_emi, yy, mm, dd);

        f :=ExcludeTrailingPathDelimiter(ALocal);
        f :=f +Format('\%.3d-%s',[Self.fil00_codigo, Self.fil00_sigla]);
        f :=f +Format('\%d.%.2d',[yy, mm]);

        if not DirectoryExists(f) then
        begin
            ForceDirectories(f);
        end;

        case ALayout of
            LayNfe		:f :=f +Format('\%s-nfe.xml',     [Self.ntf00_nfekey]);
            LayNfeProc:f :=f +Format('\%s-nfe-proc.xml',[Self.ntf00_nfekey]);
        end;

        Result  :=TNativeXml.SaveXmlToFile(xml, f);

    end;
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.SendMail(out AMsg: string): Boolean;
var mail:Tsmtp_access;
var Q:TQueryDBZ;
var dest:string  ;
var
    f_name: string;
    f_xml: string ;
    f_str: TFileStream;
    I: Integer;
var
    catalog: string ;
    support_tls: Boolean ;
begin
    Result :=False ;

    {$IFDEF DEBUG}
    dest :='gonzagaraiz@gmail.com';
    {$ELSE}
    dest := Trim(Self.cli00_emaildanfe);
    {$ENDIF}

    if dest='' then
    begin
        AMsg :='e-mail do destinatário não informado!';
        Exit;
    end;

    TMetaData.ObjExists('estnotfis00', '', catalog);
    support_tls :=catalog<>Tcatalog_table.catalog_df;

    mail:=Tsmtp_access.Create(Self.fil00_nfesmtphost,
                              Self.fil00_nfesmtpport,
                              Self.fil00_nfesmtpuser,
                              Self.fil00_nfesmtpmail,
                              Self.fil00_nfesmtppass,
                              support_tls);
    try
        if mail.Connected then
        begin
            mail.mail_dest :=dest;
            mail.smtp_helo :=Self.fil00_descri;
            mail.mail_name :=Self.fil00_descri;
            mail.mail_subj :='Envio de NF-e';

            f_xml :=Self.GetXml(LayNfeProc) ;
            if f_xml<>'' then
            begin
                f_name:=ulib.PathTemp;
                if not DirectoryExists(f_name) then
                begin
                    f_name:=ExtractFilePath(ParamStr(0));
                end;
                f_name:=IncludeTrailingPathDelimiter(f_name);
                f_name:=Format('%s%s-nfe-proc.xml',[f_name, Self.ntf00_nfekey]);

                f_str :=TFileStream.Create(f_name, fmCreate);
                try
                    f_str.WriteBuffer(f_xml[1], Length(f_xml));
                finally
                    f_str.Free ;
                end;

                if FileExists(f_name) then
                begin
                    // atacha o DANFE no envio
                    if CParent.fconfigNFe.danfe.sendmail then
                    begin
                        mail.mail_text :=Format('Anexo cópia da NF-e e DANFE referente número %d ',[Self.ntf00_rem_ntf_fis]);

                        SetLength(mail.mail_files, 2);
                        Self.PrintDANFE(odFile, '', 1, mail.mail_files[1].filename, AMsg);
                        mail.mail_files[1].typmime :=mtapppdf ;
                    end
                    else
                    begin
                        mail.mail_text :=Format('Anexo cópia da NF-e referente número %d ',[Self.ntf00_rem_ntf_fis]);
                        SetLength(mail.mail_files, 1);
                    end;

                    mail.mail_text :=mail.mail_text +FormatDateTime('"emissão "dd/mm/yyyy',Self.ntf00_rem_dat_emi);
                    mail.mail_files[0].filename :=f_name;
                    mail.mail_files[0].typmime  :=mtappbase64 ;

                    if mail.Send(mttexthtml) then
                    begin
                        AMsg := 'NF-e enviada com sucesso para '+mail.mail_dest;
                        Result :=True ;
                    end
                    else
                    begin
                        AMsg :=Format('Falha no envio da NF-e! "%s"',[mail.ErrorMsg]) ;
                    end;
                    for I :=Low(mail.mail_files) to High(mail.mail_files) do
                    begin
                        DeleteFile(mail.mail_files[I].filename);
                    end;
                end
                else
                begin
                    AMsg :=Format('Arquivo "%s" removido por outro processo!',[f_name]) ;
                end;
            end
            else
            begin
                AMsg :='Não foi possivel obter o xml no layout (nfe-proc.xml)!' ;
            end;
        end
        else
        begin
            AMsg :=mail.ErrorMsg  ;
        end;

    finally
        mail.Destroy  ;
    end;

    if not(Self.ntf00_nfesendmail) then
    begin
      AMsg :=FormatDateTime('dd/mm/yyyy hh:nn', GetSysDate(CDataBase)) +'|'+AMsg;
      q:=NewQueryDBZ(CDataBase);
      q.sql.add('update estnotfis00 set        				');
      q.sql.add('       ntf00_nfesendmail=%d					',[Ord(Result)]);
      q.sql.add('       ,ntf00_nfesendmailmsg=''%s'' 	',[AMsg]);
      q.sql.add('where ntf00_codfil=%d         				',[Self.ntf00_codfil]);
      q.sql.add('and   ntf00_codtyp=%d         				',[Self.ntf00_codtyp]);
      q.sql.add('and   ntf00_codntf=%d         				',[Self.ntf00_codntf]);
      q.ExecSQL;
      q.Destroy;
    end;

end;

{ Testnfelot00List.Testnfelot00.Testnotfis00.Testnotfis01

function Testnfelot00List.Testnfelot00.Testnotfis00.Testnotfis01.formatqtd: string;
begin
    if Self.pro00_indfrac then
        Result  :=FormatCurr('0.000', Self.ntf01_itmproqtd)
    else
        Result  :=FormatCurr('0', Self.ntf01_itmproqtd);
end;

function Testnfelot00List.Testnfelot00.Testnotfis00.Testnotfis01.vbc_red: Currency;
begin
    Result  :=Self.ntf01_itmprottl - Self.ntf01_itmrbcvlr;

end;}

{$ENDREGION}

{ Tnfecoderr00List }

constructor Tnfecoderr00List.Create;
begin
    inherited Create;
    Self.Load;
end;

function Tnfecoderr00List.CreateNew: Tnfecoderr00;
begin
    Result        :=Tnfecoderr00.Create;
    Result.Parent :=Self;
    Result.Index  :=Self.Count;
    inherited add(Result);
end;

destructor Tnfecoderr00List.Destroy;
begin
    Self.Clear;
    inherited Destroy;
end;

function Tnfecoderr00List.Get(Index: Integer): Tnfecoderr00;
begin
    Result := inherited Items[index];
end;

function Tnfecoderr00List.IndexOf(err00_codigo: Word): Tnfecoderr00;
var i:integer;
begin
    Result:= nil;
    for i :=0 to Self.Count -1 do
    begin
      if Self.Items[i].err00_codigo = err00_codigo then
      begin
        Result := Self.Items[i];
        Break;
      end;
    end;
end;

function Tnfecoderr00List.IndexOfByCod(err00_codigo: Word): string;
var e:Tnfecoderr00List.Tnfecoderr00;
begin
    e:=Self.IndexOf(err00_codigo);
    if Assigned(e) then
        Result  :=Trim(e.err00_descri)
    else
        Result  :='Erro não catalogado!';
end;

procedure Tnfecoderr00List.Load;
const arrCod: array[0..126,0..1] of string = (
    // RESULTADO DO PROCESSAMENTO DA SOLICITAÇÃO
    ('000','Lote/NF-e não enviado!                                  '),
    ('100','Autorizado o uso da NF-e                                '),
    ('101','Cancelamento de NF-e homologado                         '),
    ('102','Inutilização de número homologado                       '),
    ('103','Lote recebido com sucesso                               '),
    ('104','Lote processado                                         '),
    ('105','Lote em processamento                                   '),
    ('106','Lote não localizado                                     '),
    ('107','Serviço em Operação                                     '),
    ('108','Serviço Paralisado Momentaneamente (curto prazo)        '),
    ('109','Serviço Paralisado sem Previsão                         '),
    ('110','Uso Denegado                                            '),
    ('111','Consulta cadastro com uma ocorrência                    '),
    ('112','Consulta cadastro com mais de uma ocorrência            '),
    ('114','SCAN desabilitado pela SEFAZ-Origem MA                  '),
    // MOTIVOS DE NÃO ATENDIMENTO DA SOLICITAÇÃO
    ('201','Rejeição: O numero máximo de numeração de NF-e a inutilizar ultrapassou o limite'),
    ('202','Rejeição: Falha no reconhecimento da autoria ou integridade do arquivo digital  '),
    ('203','Rejeição: Emissor não habilitado para emissão da NF-e       '),
    ('204','Rejeição: Duplicidade de NF-e                               '),
    ('205','Rejeição: NF-e está denegada na base de dados da SEFAZ      '),
    ('206','Rejeição: NF-e já está inutilizada na Base de dados da SEFAZ'),
    ('207','Rejeição: CNPJ do emitente inválido                         '),
    ('208','Rejeição: CNPJ do destinatário inválido                     '),
    ('209','Rejeição: IE do emitente inválida                           '),
    ('210','Rejeição: IE do destinatário inválida                       '),
    ('211','Rejeição: IE do substituto inválida                         '),
    ('212','Rejeição: Data de emissão NF-e posterior a data de recebimento            '),
    ('213','Rejeição: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital'),
    ('214','Rejeição: Tamanho da mensagem excedeu o limite estabelecido   '),
    ('215','Rejeição: Falha no schema XML                                 '),
    ('216','Rejeição: Chave de Acesso difere da cadastrada                '),
    ('217','Rejeição: NF-e não consta na base de dados da SEFAZ           '),
    ('218','Rejeição: NF-e já esta cancelada na base de dados da SEFAZ    '),
    ('219','Rejeição: Circulação da NF-e verificada                       '),
    ('220','Rejeição: NF-e autorizada há mais de 7 dias (168 horas)       '),
    ('221','Rejeição: Confirmado o recebimento da NF-e pelo destinatário  '),
    ('222','Rejeição: Protocolo de Autorização de Uso difere do cadastrado'),
    ('223','Rejeição: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta'),
    ('224','Rejeição: A faixa inicial é maior que a faixa final          '),
    ('225','Rejeição: Falha no Schema XML da NFe                         '),
    ('226','Rejeição: Código da UF do Emitente diverge da UF autorizadora'),
    ('227','Rejeição: Erro na Chave de Acesso - Campo ID             '),
    ('228','Rejeição: Data de Emissão muito atrasada                 '),
    ('229','Rejeição: IE do emitente não informada                   '),
    ('230','Rejeição: IE do emitente não cadastrada                  '),
    ('231','Rejeição: IE do emitente não vinculada ao CNPJ           '),
    ('232','Rejeição: IE do destinatário não informada               '),
    ('233','Rejeição: IE do destinatário não cadastrada              '),
    ('234','Rejeição: IE do destinatário não vinculada ao CNPJ       '),
    ('235','Rejeição: Inscrição SUFRAMA inválida                     '),
    ('236','Rejeição: Chave de Acesso com dígito verificador inválido'),
    ('237','Rejeição: CPF do destinatário inválido                   '),
    ('238','Rejeição: Cabeçalho - Versão do arquivo XML superior a Versão vigente  '),
    ('239','Rejeição: Cabeçalho - Versão do arquivo XML não suportada              '),
    ('240','Rejeição: Cancelamento/Inutilização - Irregularidade Fiscal do Emitente'),
    ('241','Rejeição: Um número da faixa já foi utilizado           '),
    ('242','Rejeição: Cabeçalho - Falha no Schema XML               '),
    ('243','Rejeição: XML Mal Formado                               '),
    ('244','Rejeição: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do Emitente'),
    ('245','Rejeição: CNPJ Emitente não cadastrado                           '),
    ('246','Rejeição: CNPJ Destinatário não cadastrado                       '),
    ('247','Rejeição: Sigla da UF do Emitente diverge da UF autorizadora     '),
    ('248','Rejeição: UF do Recibo diverge da UF autorizadora                '),
    ('249','Rejeição: UF da Chave de Acesso diverge da UF autorizadora       '),
    ('250','Rejeição: UF diverge da UF autorizadora                          '),
    ('251','Rejeição: UF/Município destinatário não pertence a SUFRAMA       '),
    ('252','Rejeição: Ambiente informado diverge do Ambiente de recebimento  '),
    ('253','Rejeição: Digito Verificador da chave de acesso composta inválida'),
    ('254','Rejeição: NF-e referenciada não informada para NF-e complementar '),
    ('255','Rejeição: Informada mais de uma NF-e referenciada para NF-e complementar '),
    ('256','Rejeição: Uma NF-e da faixa já está inutilizada na Base de dados da SEFAZ'),
    ('257','Rejeição: Solicitante não habilitado para emissão da NF-e        '),
    ('258','Rejeição: CNPJ da consulta inválido                              '),
    ('259','Rejeição: CNPJ da consulta não cadastrado como contribuinte na UF'),
    ('260','Rejeição: IE da consulta inválida                                '),
    ('261','Rejeição: IE da consulta não cadastrada como contribuinte na UF  '),
    ('262','Rejeição: UF não fornece consulta por CPF                        '),
    ('263','Rejeição: CPF da consulta inválido                               '),
    ('264','Rejeição: CPF da consulta não cadastrado como contribuinte na UF '),
    ('265','Rejeição: Sigla da UF da consulta difere da UF do Web Service    '),
    ('266','Rejeição: Série utilizada não permitida no Web Service           '),
    ('267','Rejeição: NF Complementar referencia uma NF-e inexistente        '),
    ('268','Rejeição: NF Complementar referencia uma outra NF-e Complementar '),
    ('269','Rejeição: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada'),
    ('270','Rejeição: Código Município do Fato Gerador: dígito inválido             '),
    ('271','Rejeição: Código Município do Fato Gerador: difere da UF do emitente    '),
    ('272','Rejeição: Código Município do Emitente: dígito inválido                 '),
    ('273','Rejeição: Código Município do Emitente: difere da UF do emitente        '),
    ('274','Rejeição: Código Município do Destinatário: dígito inválido             '),
    ('275','Rejeição: Código Município do Destinatário: difere da UF do Destinatário'),
    ('276','Rejeição: Código Município do Local de Retirada: dígito inválido        '),
    ('277','Rejeição: Código Município do Local de Retirada: difere da UF do Local de Retirada'),
    ('278','Rejeição: Código Município do Local de Entrega: dígito inválido                   '),
    ('279','Rejeição: Código Município do Local de Entrega:  difere da UF do Local de Entrega '),
    ('280','Rejeição: Certificado Transmissor inválido                                 '),
    ('281','Rejeição: Certificado Transmissor Data Validade                            '),
    ('282','Rejeição: Certificado Transmissor sem CNPJ                                 '),
    ('283','Rejeição: Certificado Transmissor - erro Cadeia de Certificação            '),
    ('284','Rejeição: Certificado Transmissor revogado                                 '),
    ('285','Rejeição: Certificado Transmissor difere ICP-Brasil                        '),
    ('286','Rejeição: Certificado Transmissor erro no acesso a LCR                     '),
    ('287','Rejeição: Código Município do FG - ISSQN: dígito inválido                  '),
    ('288','Rejeição: Código Município do FG - Transporte: dígito inválido             '),
    ('289','Rejeição: Código da UF informada diverge da UF solicitada                  '),
    ('290','Rejeição: Certificado Assinatura inválido                                  '),
    ('291','Rejeição: Certificado Assinatura Data Validade                             '),
    ('292','Rejeição: Certificado Assinatura sem CNPJ                                  '),
    ('293','Rejeição: Certificado Assinatura - erro Cadeia de Certificação             '),
    ('294','Rejeição: Certificado Assinatura revogado                                  '),
    ('295','Rejeição: Certificado Assinatura difere ICP-Brasil                         '),
    ('296','Rejeição: Certificado Assinatura erro no acesso a LCR                      '),
    ('297','Rejeição: Assinatura difere do calculado                                   '),
    ('298','Rejeição: Assinatura difere do padrão do Projeto                           '),
    ('299','Rejeição: XML da área de cabeçalho com codificação diferente de UTF-8      '),
    ('401','Rejeição: CPF do remetente inválido                                        '),
    ('402','Rejeição: XML da área de dados com codificação diferente de UTF-8          '),
    ('403','Rejeição: O grupo de informações da NF-e avulsa é de uso exclusivo do Fisco'),
    ('404','Rejeição: Uso de prefixo de namespace não permitido                        '),
    ('405','Rejeição: Código do país do emitente: dígito inválido                      '),
    ('406','Rejeição: Código do país do destinatário: dígito inválido                  '),
    ('407','Rejeição: O CPF só pode ser informado no campo emitente para a NF-e avulsa '),
    ('453','Rejeição: Ano de inutilização não pode ser superior ao Ano atual  '),
    ('454','Rejeição: Ano de inutilização não pode ser inferior a 2006        '),
    ('478','Rejeição: Local da entrega não informado para faturamento direto de veículos novos'),
    ('999','Rejeição: Erro não catalogado                                     '),
    // MOTIVOS DE DENEGAÇÃO DE USO
    ('301','Uso Denegado : Irregularidade fiscal do emitente                  '),
    ('302','Uso Denegado : Irregularidade fiscal do destinatário              ')
  );
var e:Tnfecoderr00List.Tnfecoderr00;
var i:Word;
var c:Word;
    //
    function ConvertCod(const ACod: String): Word;
    begin
        Result  :=StrToIntDef(ACod, 0);
    end;
    //
begin
    for i:=Low(arrCod) to High(arrCod) do
    begin
        c:=ConvertCod(arrCod[i, 0]);
        e:=Self.IndexOf(c);
        if e=nil then
        begin
            e             :=Self.CreateNew;
            e.err00_codigo:=c;
            e.err00_descri:=arrCod[i, 1];
        end;
    end;
end;


{ Testtipfis01List }

function Testtipfis01List.AddNew: Testtipfis01;
begin
    Result         :=Testtipfis01.Create;
    Result.fOwner :=Self;
    inherited Add(Result);
end;

function Testtipfis01List.Get(Index: Integer): Testtipfis01;
begin
    Result  :=Testtipfis01(inherited Items[Index]);
end;

function Testtipfis01List.IndexOf(const codfis: Integer;
  const aliq_icms: Currency): Testtipfis01;
var
    I:Integer;
begin
    Result:=nil;
    for i:=0 to Self.Count -1 do
    begin
        if(Self.Items[i].codfis   =codfis   )and
          (Self.Items[i].aliq_icms=aliq_icms)then
        begin
            Result :=Self.Items[i];
            Break;
        end;
    end;
end;

procedure Testtipfis01List.Load(const codfil, codntf, codtyp: Integer);
var q:TQueryDBZ;

var f:Testtipfis01;

var ffis01_codfis         :TField;
var ffis01_codtyp         :TField;
var ffis01_fis_int_fis_ms1:TField;
var ffis01_fis_int_fis_ms2:TField;
var ffis01_fis_int_fis_ms3:TField;
var ffis01_fis_int_jur_ms1:TField;
var ffis01_fis_int_jur_ms2:TField;
var ffis01_fis_int_jur_ms3:TField;
var ffis01_fis_ext_fis_ms1:TField;
var ffis01_fis_ext_fis_ms2:TField;
var ffis01_fis_ext_fis_ms3:TField;
var ffis01_fis_ext_jur_ms1:TField;
var ffis01_fis_ext_jur_ms2:TField;
var ffis01_fis_ext_jur_ms3:TField;

var fntf01_itmpericm:TField;
var fntf01_itmicmbas:TField;
var fntf01_itmproicm:TField;
var fntf01_itmprottl:TField;

var catalog: string ;

begin
    //
    Self.Clear;
    //
    q :=NewQueryDBZ(CDataBase);
    q.sql.Clear;
    q.sql.Add('select                                                        ');
    q.sql.Add('   fis01_codfis            ,                                  ');
    q.sql.Add('   fis01_codtyp            ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms3   ,                                  ');
    q.sql.Add('   ntf01_itmpericm  ,                                         ');

    if TMetaData.ObjExists('estnotfis01','ntf01_itmicmbas', catalog) then
    begin
      // na "embale" e "info.mania" o valor de redução esta incluso na BC
      if(catalog=Tcatalog_table.catalog_em)or(catalog=Tcatalog_table.catalog_if) then
      begin
        q.sql.Add(' sum(ntf01_itmicmbas -ntf01_itmrbcvlr) as ntf01_itmicmbas,');
      end
      // Para os outros clientes a base ja está reduzida
      else begin
        q.sql.Add(' sum(ntf01_itmicmbas)  as ntf01_itmicmbas,                ');
      end;
    end
    else
    begin
      q.sql.Add(' sum(ntf01_itmprottl -ntf01_itmrbcvlr) as ntf01_itmicmbas,  ');
    end;

    q.sql.Add('   sum(ntf01_itmproicm)  as ntf01_itmproicm,                  ');
    q.sql.Add(' 	sum(ntf01_itmprottl)  as ntf01_itmprottl                 	 ');
    q.sql.Add('from estnotfis01(nolock)                                      ');

    // campo (fis00_codreg) link com a estfil00 (embale)
    if TMetaData.ObjExists('esttipfis01','fis01_codreg')and(catalog=Tcatalog_table.catalog_em) then
    begin
      q.sql.Add('inner join estfil00(nolock)    on fil00_codfil =ntf01_codfil   ');
      q.sql.Add('inner join esttipfis00(nolock) on fis00_codigo =ntf01_itmcodfis');
      q.sql.Add('                              and fis00_codreg =fil00_codtpf   ');
      q.sql.Add('inner join esttipfis01(nolock) on fis01_codreg =fis00_codreg   ');
      q.sql.Add('                              and fis01_codfis =fis00_codigo   ');
      q.sql.Add('                              and fis01_codtyp =fis00_typfis   ');
    end
    else begin
      q.sql.Add('inner join esttipfis00(nolock) on fis00_codigo=ntf01_itmcodfis');
      q.sql.Add('inner join esttipfis01(nolock) on fis01_codfis=fis00_codigo   ');
      q.sql.Add('                              and fis01_codtyp=fis00_typfis   ');
    end;

    q.sql.Add('where ntf01_codfil = %d                                       ',[codfil]);
    q.sql.Add('  and ntf01_codtyp = %d                                       ',[codtyp]);
    q.sql.Add('  and ntf01_codntf = %d                                       ',[codntf]);
    q.sql.Add('group by                                                      ');
    q.sql.Add('   fis01_codfis            ,                                  ');
    q.sql.Add('   fis01_codtyp            ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_int_fis_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_int_jur_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_ext_fis_ms3   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms1   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms2   ,                                  ');
    q.sql.Add('   fis01_fis_ext_jur_ms3   ,                                  ');
    q.sql.Add('   ntf01_itmpericm                                            ');
    q.sql.Add('order by fis01_codfis                                         ');
    q.Open;

    ffis01_codfis           :=q.Field('fis01_codfis         ');
    ffis01_codtyp           :=q.Field('fis01_codtyp         ');
    ffis01_fis_int_fis_ms1  :=q.Field('fis01_fis_int_fis_ms1');
    ffis01_fis_int_fis_ms2  :=q.Field('fis01_fis_int_fis_ms2');
    ffis01_fis_int_fis_ms3  :=q.Field('fis01_fis_int_fis_ms3');
    ffis01_fis_int_jur_ms1  :=q.Field('fis01_fis_int_jur_ms1');
    ffis01_fis_int_jur_ms2  :=q.Field('fis01_fis_int_jur_ms2');
    ffis01_fis_int_jur_ms3  :=q.Field('fis01_fis_int_jur_ms3');
    ffis01_fis_ext_fis_ms1  :=q.Field('fis01_fis_ext_fis_ms1');
    ffis01_fis_ext_fis_ms2  :=q.Field('fis01_fis_ext_fis_ms2');
    ffis01_fis_ext_fis_ms3  :=q.Field('fis01_fis_ext_fis_ms3');
    ffis01_fis_ext_jur_ms1  :=q.Field('fis01_fis_ext_jur_ms1');
    ffis01_fis_ext_jur_ms2  :=q.Field('fis01_fis_ext_jur_ms2');
    ffis01_fis_ext_jur_ms3  :=q.Field('fis01_fis_ext_jur_ms3');

    fntf01_itmpericm :=q.Field('ntf01_itmpericm');
    fntf01_itmicmbas :=q.Field('ntf01_itmicmbas');
    fntf01_itmproicm :=q.Field('ntf01_itmproicm');
    fntf01_itmprottl :=q.Field('ntf01_itmprottl');

    while not q.Eof do
    begin
      f :=Self.IndexOf(ffis01_codfis.AsInteger, fntf01_itmpericm.AsCurrency);
      if f = nil then
      begin
          f :=Self.AddNew;
          f.codfis    :=ffis01_codfis.AsInteger;
          f.aliq_icms :=fntf01_itmpericm.AsCurrency;
          f.vlr_bc_icms :=fntf01_itmicmbas.AsCurrency ;
          f.vlr_icms    :=fntf01_itmproicm.AsCurrency ;
          f.vlr_tot    	:=fntf01_itmprottl.AsCurrency ;
          if Self.PesFis then
          begin
              if Self.OpeInt then
              begin
                  f.msg_01  :=ffis01_fis_int_fis_ms1.AsString;
                  f.msg_02  :=ffis01_fis_int_fis_ms2.AsString;
                  f.msg_03  :=ffis01_fis_int_fis_ms3.AsString;
              end
              else begin
                  f.msg_01  :=ffis01_fis_ext_fis_ms1.AsString;
                  f.msg_02  :=ffis01_fis_ext_fis_ms2.AsString;
                  f.msg_03  :=ffis01_fis_ext_fis_ms3.AsString;
              end;
          end
          else begin
              if Self.OpeInt then
              begin
                  f.msg_01  :=ffis01_fis_int_jur_ms1.AsString;
                  f.msg_02  :=ffis01_fis_int_jur_ms2.AsString;
                  f.msg_03  :=ffis01_fis_int_jur_ms3.AsString;
              end
              else begin
                  f.msg_01  :=ffis01_fis_ext_jur_ms1.AsString;
                  f.msg_02  :=ffis01_fis_ext_jur_ms2.AsString;
                  f.msg_03  :=ffis01_fis_ext_jur_ms3.AsString;
              end;
          end;
      end
      else begin
          f.vlr_bc_icms :=f.vlr_bc_icms +fntf01_itmicmbas.AsCurrency;
          f.vlr_icms    :=f.vlr_icms    +fntf01_itmproicm.AsCurrency;
          f.vlr_tot    	:=f.vlr_tot			+fntf01_itmprottl.AsCurrency;
      end;

      q.Next;
    end;
    q.Close;
    q.Destroy;
end;


procedure Testtipfis01List.LoadMsg(const codfil, codntf, codtyp: Integer);
var q:TQueryDBZ;

var f:Testtipfis01;

var fntf01_itmcodfis:TField;
    fntf01_itmpericm:TField;

var ffis01_codtyp         :TField;
var ffis01_fis_int_fis_ms1:TField;
var ffis01_fis_int_fis_ms2:TField;
var ffis01_fis_int_fis_ms3:TField;
var ffis01_fis_int_jur_ms1:TField;
var ffis01_fis_int_jur_ms2:TField;
var ffis01_fis_int_jur_ms3:TField;
var ffis01_fis_ext_fis_ms1:TField;
var ffis01_fis_ext_fis_ms2:TField;
var ffis01_fis_ext_fis_ms3:TField;
var ffis01_fis_ext_jur_ms1:TField;
var ffis01_fis_ext_jur_ms2:TField;
var ffis01_fis_ext_jur_ms3:TField;

var catalog: string;

begin
    //
    //
    q :=NewQueryDBZ(CDataBase);
    q.sql.Add('select distinct          ');
    q.sql.Add('   ntf01_itmcodfis      ,');
    q.sql.Add('   ntf01_itmpericm      ,');
    q.sql.Add('   fis01_codtyp         ,');
    q.sql.Add('   fis01_fis_int_fis_ms1,');
    q.sql.Add('   fis01_fis_int_fis_ms2,');
    q.sql.Add('   fis01_fis_int_fis_ms3,');
    q.sql.Add('   fis01_fis_int_jur_ms1,');
    q.sql.Add('   fis01_fis_int_jur_ms2,');
    q.sql.Add('   fis01_fis_int_jur_ms3,');
    q.sql.Add('   fis01_fis_ext_fis_ms1,');
    q.sql.Add('   fis01_fis_ext_fis_ms2,');
    q.sql.Add('   fis01_fis_ext_fis_ms3,');
    q.sql.Add('   fis01_fis_ext_jur_ms1,');
    q.sql.Add('   fis01_fis_ext_jur_ms2,');
    q.sql.Add('   fis01_fis_ext_jur_ms3 ');
    q.sql.Add('from estnotfis01(nolock) ');

    // campo (fis00_codreg) link com a estfil00 (embale)
    if TMetaData.ObjExists('esttipfis01','fis01_codreg', catalog)and(catalog=Tcatalog_table.catalog_em) then
    begin
      q.sql.Add('inner join estfil00(nolock)    on fil00_codfil =ntf01_codfil   ');
      q.sql.Add('inner join esttipfis00(nolock) on fis00_codigo =ntf01_itmcodfis');
      q.sql.Add('                              and fis00_codreg =fil00_codtpf   ');
      q.sql.Add('inner join esttipfis01(nolock) on fis01_codreg =fis00_codreg   ');
      q.sql.Add('                              and fis01_codfis =fis00_codigo   ');
      q.sql.Add('                              and fis01_codtyp =fis00_typfis   ');
    end
    else begin
      q.sql.Add('inner join esttipfis00(nolock) on fis00_codigo=ntf01_itmcodfis');
      q.sql.Add('inner join esttipfis01(nolock) on fis01_codfis=fis00_codigo   ');
      q.sql.Add('                              and fis01_codtyp=fis00_typfis   ');
    end;

    q.sql.Add('where  ntf01_codfil = %d',[codfil]);
    q.sql.Add('and    ntf01_codntf = %d',[codntf]);
    q.sql.Add('and    ntf01_codtyp = %d',[codtyp]);
    q.sql.Add('order by ntf01_itmcodfis');
    q.Open;

    fntf01_itmcodfis  :=q.Field('ntf01_itmcodfis');
    fntf01_itmpericm  :=q.Field('ntf01_itmpericm');
    ffis01_codtyp     :=q.Field('fis01_codtyp   ');
    ffis01_fis_int_fis_ms1  :=q.Field('fis01_fis_int_fis_ms1');
    ffis01_fis_int_fis_ms2  :=q.Field('fis01_fis_int_fis_ms2');
    ffis01_fis_int_fis_ms3  :=q.Field('fis01_fis_int_fis_ms3');
    ffis01_fis_int_jur_ms1  :=q.Field('fis01_fis_int_jur_ms1');
    ffis01_fis_int_jur_ms2  :=q.Field('fis01_fis_int_jur_ms2');
    ffis01_fis_int_jur_ms3  :=q.Field('fis01_fis_int_jur_ms3');
    ffis01_fis_ext_fis_ms1  :=q.Field('fis01_fis_ext_fis_ms1');
    ffis01_fis_ext_fis_ms2  :=q.Field('fis01_fis_ext_fis_ms2');
    ffis01_fis_ext_fis_ms3  :=q.Field('fis01_fis_ext_fis_ms3');
    ffis01_fis_ext_jur_ms1  :=q.Field('fis01_fis_ext_jur_ms1');
    ffis01_fis_ext_jur_ms2  :=q.Field('fis01_fis_ext_jur_ms2');
    ffis01_fis_ext_jur_ms3  :=q.Field('fis01_fis_ext_jur_ms3');

    while not q.Eof do
    begin
      f :=Self.IndexOf(fntf01_itmcodfis.AsInteger, fntf01_itmpericm.AsCurrency);
      if f<>nil then
      begin
          if Self.PesFis then
          begin
              if Self.OpeInt then
              begin
                  f.msg_01  :=ffis01_fis_int_fis_ms1.AsString;
                  f.msg_02  :=ffis01_fis_int_fis_ms2.AsString;
                  f.msg_03  :=ffis01_fis_int_fis_ms3.AsString;
              end
              else begin
                  f.msg_01  :=ffis01_fis_ext_fis_ms1.AsString;
                  f.msg_02  :=ffis01_fis_ext_fis_ms2.AsString;
                  f.msg_03  :=ffis01_fis_ext_fis_ms3.AsString;
              end;
          end
          else begin
              if Self.OpeInt then
              begin
                  f.msg_01  :=ffis01_fis_int_jur_ms1.AsString;
                  f.msg_02  :=ffis01_fis_int_jur_ms2.AsString;
                  f.msg_03  :=ffis01_fis_int_jur_ms3.AsString;
              end
              else begin
                  f.msg_01  :=ffis01_fis_ext_jur_ms1.AsString;
                  f.msg_02  :=ffis01_fis_ext_jur_ms2.AsString;
                  f.msg_03  :=ffis01_fis_ext_jur_ms3.AsString;
              end;
          end;
      end ;
      q.Next;
    end;
    q.Close;
    q.Destroy;
end;


end.
