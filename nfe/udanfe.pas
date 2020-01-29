unit udanfe;

interface

{$REGION 'uses'}
uses Windows    ,
    Messages    ,
    SysUtils    ,
    Classes     ,
    Contnrs     ,
    ExtCtrls    ,
    Graphics    ,
    Forms ,

    // RAVE
    RpBase      ,
    RpFiler     ,
    RpSystem    ,
    RpRender    ,
    RpRenderPDF ,
    RpDefine    ,
    rpBars      ,
    RpDevice    ,
    RpMemo 			,

    //
    unfexml     ,
    urave
{$IFDEF NFCE}
    ,psBarcodeComp
    ,psTypes
    ,psCodeStudio
{$ENDIF}
    ;
{$ENDREGION}


type
  TCustomDANFe = class;

  TdanfeColumn = class(TCollectionItem)
  public
    Caption: string ;
    PosX: Double;
    Width: Double;
    Justify: TPrintJustify;
    Border: Byte;
    Shade: Byte;
    Margin: Double;
    Visible: Boolean;
    constructor Create(Collection: TCollection); override;
  end;

  TdanfeColumns =class(TCollection)
  private
    function Get(Index: Integer): TdanfeColumn;
  public
    property Items[Index: Integer]: TdanfeColumn read Get;
    function Add: TdanfeColumn;
  end;

  TdanfeQuadro = class
  public
    Altura: Double ;
    Largura: Double;
    Titulo: string ;
    Texto: string ;
    Just: TPrintJustify;
    Bold: Boolean ;
    Rotacao: Integer;
    posX, posY: Double;
  public
    constructor Create;
    procedure DoConfig(const Altura, Largura: Double;
      const Titulo: string ='';
      const Texto: string ='';
      const Just: TPrintJustify =pjLeft;
      const Bold: Boolean = False;
      const Rotacao: Integer =0);
  end;

  TdanfeBloco = class(TObject)
  private
    Owner: TCustomDANFe;
    FPrintBloco: Boolean;
    procedure PQuadro(const AposX, AposY: Double;
                      const AQuadro: TdanfeQuadro;
                      const ABold: Boolean =False);

  protected
    class var X: Double;
    class var Y: Double;
    class var Text: string ;
    const DIST_IN_BLOCO = 0.30;

  protected
    { Fonts oficiais no DANFE }
    const FONT_TIMES_NW = 'Times New Roman';
    const FONT_COURIER_NW = 'Courier New';
    const FONT_SIZE_6 = 6;
    const FONT_SIZE_8 = 8;
    const FONT_SIZE_10 = 10;
    const FONT_SIZE_12 = 12;
    const FONT_SIZE_14 = 14;

  public
    property PrintBloco: Boolean read FPrintBloco write FPrintBloco ;
    procedure DoPrint(); virtual; abstract ;
  end;

  TdanfeBlcCanhoto = class(TdanfeBloco)
  public
    QReceb: TdanfeQuadro ;
    QDataReceb: TdanfeQuadro;
    QAssina: TdanfeQuadro ;
    QIdNFE: TdanfeQuadro ;
  public
    constructor Create(AOwner: TCustomDANFe);
    destructor Destroy; override ;
    procedure DoPrint(); override;
    procedure DoPrintLandScape();
  end;

  TdanfeBlcCab = class(TdanfeBloco)
  private
    FLogo: string;
    FBitmap: TBitmap;
    procedure SetLogo(const Value: string);
  public
    QIdEmit: TdanfeQuadro;
    QDanfe: TdanfeQuadro ;
    QCodBar: TdanfeQuadro;
    QChave: TdanfeQuadro ;
    QCampo1: TdanfeQuadro;
    QNatOpe: TdanfeQuadro;
    QCampo2: TdanfeQuadro;
    QIE: TdanfeQuadro;
    QIEST: TdanfeQuadro;
    QCNPJ: TdanfeQuadro;
  public
    property Logotipo: string read FLogo write SetLogo ;
    constructor Create(AOwner: TCustomDANFe);
    destructor Destroy; override ;
    procedure DoPrint(); override ;
  end;

  TdanfeBlcDestRem = class(TdanfeBloco)
  public
    QNome: TdanfeQuadro;
    QCNPJ: TdanfeQuadro;
    QDtEmis: TdanfeQuadro;
    QEnd: TdanfeQuadro;
    QBairro: TdanfeQuadro;
    QCEP: TdanfeQuadro;
    QDtEntSai: TdanfeQuadro;
    QMun: TdanfeQuadro;
    QFone: TdanfeQuadro;
    QUF: TdanfeQuadro;
    QIE: TdanfeQuadro;
    QHrEntSai: TdanfeQuadro;
  public
    constructor Create(AOwner: TCustomDANFe);
    destructor Destroy; override ;
    procedure DoPrint(); override ;
  end;

  TdanfeBlcCobr = class(TdanfeBloco)
  private
    FColumns: TdanfeColumns;
  public
    property Colunas: TdanfeColumns read FColumns;
    constructor Create(AOwner: TCustomDANFe);
    destructor Destory;
    procedure DoPrint(); override;
  end;

  TdanfeBlcCalcImposto = class(TdanfeBloco)
  public
    QvBC: TdanfeQuadro;
    QvICMS: TdanfeQuadro;
    QvBCST: TdanfeQuadro;
    QvST: TdanfeQuadro;
    QvProd: TdanfeQuadro;
    QvFrete: TdanfeQuadro;
    QvSeg: TdanfeQuadro;
    QvDesc: TdanfeQuadro;
    QvOutro: TdanfeQuadro;
    QvIPI: TdanfeQuadro;
    QvNF: TdanfeQuadro;
//    QvTotTrib: TdanfeQuadro;
  public
    constructor Create(AOwner: TCustomDANFe);
    destructor Destory;
    procedure DoPrint(); override ;
  end;

  TdanfeBlcTransp = class(TdanfeBloco)
  public
    QNome: TdanfeQuadro;
    QFrete: TdanfeQuadro;
    QCodANTT: TdanfeQuadro;
    QPlcNum: TdanfeQuadro;
    QPlcUF: TdanfeQuadro;
    QCNPJ: TdanfeQuadro;
    QEnd: TdanfeQuadro;
    QMun: TdanfeQuadro;
    QUF: TdanfeQuadro;
    QIE: TdanfeQuadro;
    QQtdVol: TdanfeQuadro;
    QEsp: TdanfeQuadro;
    QMarca: TdanfeQuadro;
    QNum: TdanfeQuadro;
    QPesoBrt: TdanfeQuadro;
    QPesoLiq: TdanfeQuadro;
  public
    constructor Create(AOwner: TCustomDANFe);
    destructor Destory;
    procedure DoPrint(); override;
  end;

  TdanfeProdColumn = (pcCProd, pcXProd, pcVFrete, pcVSeg, pcVOutro,
    pcNCM, pcCST, pcCFOP, pcUnid, pcQtde, pcVUnit, pcVDesc, pcVTot,
    pcVBC, pcVBCST, pcVICMS, pcVICMSST, pcVIPI, pcAliqICMS, pcAliqIPI );
  TdanfeProdColumnSet = set of TdanfeProdColumn;
  TdanfeBlcProd = class(TdanfeBloco)
  private
    FColumns: TdanfeColumns;
    FInfAdProd: Boolean;
    FVisibleColumns: TdanfeProdColumnSet;
    procedure CreateColumns();
    procedure SetColumns(const Value: TdanfeProdColumnSet);
  public
    property Colunas: TdanfeColumns read FColumns ;
    property InfAdProd: Boolean read FInfAdProd write FInfAdProd;
    constructor Create(AOwner: TCustomDANFe);
    destructor Destory;
    procedure DoPrint(); override;
    procedure SetColumn(const Order: TdanfeProdColumn;
      const Caption: string ;
      const PosX, Width: Double;
      const Just: TPrintJustify;
      const Border: Byte =BOXLINELEFTRIGHT) ;
  end;

  TdanfeBlcAdic = class(TdanfeBloco)
  public
    QInfCpl: TdanfeQuadro;
    QInfFis: TdanfeQuadro;
  public
    constructor Create(AOwner: TCustomDANFe);
    destructor Destory;
    procedure DoPrint(); override;
  end;

  TCustomDANFe = class(TRvCustomCodBase)
    procedure DoInit(Sender: TObject); override ;
    //procedure DoPrint(Sender: TObject); override ;
  private
    FBlcCanhoto: TdanfeBlcCanhoto ;
    FBlcCab: TdanfeBlcCab ;
    FBlcDestRem: TdanfeBlcDestRem;
    FBlcFatDups: TdanfeBlcCobr ;
    FBlcCalcImposto: TdanfeBlcCalcImposto;
    FBlcTransp: TdanfeBlcTransp ;
    FBlcProd: TdanfeBlcProd ;
    FBlcAdic: TdanfeBlcAdic ;

  protected
    { Fonts oficiais no DANFE }
    const FONT_TIMES_NW = 'Times New Roman';
    const FONT_COURIER_NW = 'Courier New';
    const FONT_SIZE_6 = 6;
    const FONT_SIZE_8 = 8;
    const FONT_SIZE_10 = 10;
    const FONT_SIZE_12 = 12;
    const FONT_SIZE_14 = 14;

    { Index da tabelas/colunas no DANFE }
    const TAB_DUP_COL1 =1;
    const TAB_DUP_COL2 =TAB_DUP_COL1 +1;
    const TAB_PROD =5;
    const TAB_PROD_AD =TAB_PROD +1;

  protected
    NFe    : TNFe;
    infProt: TinfProt;
    ItensPorPag: Integer;
    procedure DoCreateColumnsCobr; virtual; abstract ;
    procedure DoCreateColumnsProd; virtual; abstract ;
    procedure DoSetColumnsProd; virtual; abstract ;
    procedure DoConfigBloco; virtual; abstract ;

  public
    property BlcCanhoto: TdanfeBlcCanhoto read FBlcCanhoto;
    property BlcCab: TdanfeBlcCab read FBlcCab write FBlcCab;
    property BlcDestRem: TdanfeBlcDestRem read FBlcDestRem;
    property BlcFatDups: TdanfeBlcCobr read FBlcFatDups ;
    property BlcCalcImposto: TdanfeBlcCalcImposto read FBlcCalcImposto;
    property BlcTransp: TdanfeBlcTransp read FBlcTransp;
    property BlcProd: TdanfeBlcProd read FBlcProd;
    property BlcAdic: TdanfeBlcAdic read FBlcAdic;

    constructor Create(AOrientation: TRvOrientation);
    destructor Destroy; override;

    procedure RenderToPrinter(const APrinterName: string;
      const ACopies: Integer =1);
    procedure RenderToPDF(const ALocal: string);

  end;

  TDANFeRetrato = class(TCustomDANFe)
    procedure DoPrint(Sender: TObject); override;
  protected
    procedure DoConfigBloco; override;
    procedure DoCreateColumnsCobr; override;
    procedure DoSetColumnsProd; override;

  public
    constructor Create(ANFe: TNFe; AinfProt: TinfProt);

  end;

  TDANFePaisagem = class(TCustomDANFe)
    procedure DoPrint(Sender: TObject); override;
  protected
    procedure DoConfigBloco; override ;
    procedure DoCreateColumnsCobr; override;
    procedure DoCreateColumnsProd; override;

  public
    constructor Create(ANFe: TNFe; AinfProt: TinfProt);

  end;

{$IFDEF NFCE}
  TDANFe_NFCe = class(TCustomDANFe)
    procedure DoPrint(Sender: TObject); override;
  private
    function GetUrl: string ;
  protected
    Image: TImage ;
    Barcode: TpsBarcodeComponent;
    procedure DoSetColumnsProd; override;
  public
    property Url: string read GetUrl;
    constructor Create(ANFe: TNFe; AinfProt: TinfProt);
    destructor Destroy; override;
    function QRCode(const FullToken: Boolean): string ;
    function cHashQRCode: string ;
  end;
{$ENDIF}

{$REGION 'TnfeDanfe'}
type
    TOutiputDanfe = (odPreview, odPrinter, odFile);

    TBaseReportExt = class helper for TBaseReport
    public
      procedure PrintTab(	const Index: Integer;
                          const Text: string;
                          const BoxLine: Byte); overload;
    end;

    TnfeDanfe = class(TRvSystem)
    private
      fDeviceName :string ;
      fCopies     :Integer;
      fLogo       :string;
      fAbortMsg :string;
      procedure SetOut(AValue: TOutiputDanfe);
      procedure SetCopies(AValue: Integer);
      procedure SetLogo(AValue: string);
    protected
      fRvRenderPDF: TRvRenderPDF;
      fNFe    :TNFe;
      finfProt:TinfProt;
      fBitmap :TBitmap;
      procedure DoInit(Sender: TObject);
      procedure DoPrint(Sender: TObject);
      procedure DoStatus(ReportSystem: TRvSystem; OverrideMode: TOverrideMode;
      var OverrideForm: TForm) ;
    public
      constructor Create(ANFe: TNFe; AOut: TOutiputDanfe; AinfProt: TinfProt=nil); reintroduce ;
      destructor Destroy; override;
      function Print: Boolean;
    published
      property DeviceName :string         read fDeviceName  write fDeviceName;
      property Copies     :Integer        read fCopies      write SetCopies  ;
      property Logo       :string         read fLogo        write SetLogo    ;
//      property DataCont 	:TDateTime			read fDataCont		write fDataCont;
//      property JustCont 	:string					read fJustCont		write fJustCont;
      property AbortMsg   :string         read fAbortMsg                     ;
    end;
{$ENDREGION}

implementation

uses StrUtils, DateUtils, jpeg ,
  RpFormStatus,
  unfeutil;

type  Tdanfe_font = record
    	public
          Name: TFontName;
          Size: Integer;
          Color: TColor;
          Style: TFontStyles;
      end;

{$REGION 'const´s'}
const
    FONT_TIMES_NW = 'Times New Roman';
    FONT_COURIER_NW = 'Courier New';
    FONT_SIZE_06 = 06;
    FONT_SIZE_07 = 07;
    FONT_SIZE_08 = 08;
    FONT_SIZE_10 = 10;
    FONT_SIZE_12 = 12;
    FONT_SIZE_14 = 14;

const
    WCODIGO_PRODUTO = 1.27;
    WDESCRI_PRODUTO = 5.83 ;
    WNCM_SH = 1.25;
    WCST = 0.56;
    WCFOP = 0.76;
    WUNID = 0.50;
    WQUANT = 1.32;
    WVLR_UNIT = 1.27;
    WVLR_TOT = 1.35;
    WBC_ICMS = 1.37;
    WVLR_ICMS = 1.27;
    WVLR_IPI = 0.91;
    WALIQ_ICMS = 0.96;
    WALIQ_IPI = 0.76;
    WLINEAD =	WDESCRI_PRODUTO	+WNCM_SH 		+WCST 			+WCFOP		+WUNID	+
    					WQUANT 					+WVLR_UNIT 	+WVLR_TOT		+WBC_ICMS	+
              WVLR_ICMS				+WVLR_IPI  	+WALIQ_ICMS +WALIQ_IPI;
{$ENDREGION}


{ TnfeDanfe }

constructor TnfeDanfe.Create(ANFe: TNFe; AOut: TOutiputDanfe; AinfProt: TinfProt);
begin

  inherited Create(nil);
  //
  fBitmap :=TBitmap.Create;

  //
  fRvRenderPDF:=TRvRenderPDF.Create(nil);
  fRvRenderPDF.EmbedFonts  :=True;
  fRvRenderPDF.ImageQuality:=90;
  fRvRenderPDF.MetafileDPI:=300;
  fRvRenderPDF.UseCompression:=False;
  fRvRenderPDF.Active:=True;

  TitlePreview  :=Format('%s-nfe', [ANFe.Id])
  ;

  // saida
  case AOut of
      odPreview:
      begin
          DefaultDest :=rdPreview;
      end;
      odPrinter:
      begin
          DefaultDest :=rdPrinter;
          SystemPrinter.Title :=TitlePreview  ;
      end;
      odFile   :
      begin
          //
          DefaultDest     :=rdFile;
          DoNativeOutput  :=False;
          RenderObject    :=fRvRenderPDF;
          OutputFileName  :=Format('%s%s.pdf', [ExtractFilePath(ParamStr(0)),TitlePreview]);
      end;
  end;

  // ...
  SystemPrinter.Units         :=unCM;
  SystemPrinter.UnitsFactor   :=2.54;
  SystemSetups :=SystemSetups -[ssAllowSetup];
  SystemPreview.RulerType     :=rtBothCm;

  fCopies   :=1;
  //fAborted  :=False;

  fNFe    :=ANFe;
  finfProt:=AinfProt;

  OnBeforePrint :=DoInit;
  OnPrint       :=DoPrint;

end;

destructor TnfeDanfe.Destroy;
begin
  fBitmap.Destroy;
  fRvRenderPDF.Destroy;
  inherited Destroy;
end;

procedure TnfeDanfe.DoInit(Sender: TObject);
const
  WDUP_NRO = 3.21; //2.00;
  WDUP_VENC = 3.42; // 2.34;
  WDUP_VALR = 3.00; //2.14;
  WDUP_AGT = 2.14;
var rpt: RpBase.TBaseReport;
begin
  fAbortMsg   :='DANFE impresso com sucesso.';

  rpt :=Self.BaseReport; //(Sender as TBaseReport);
  if DefaultDest = rdPrinter then
  begin
      if fDeviceName = '' then
      begin
          if not rpt.ShowPrinterSetupDialog then
          begin
              fAbortMsg :='Impressora não selecionada!';
              rpt.Abort;
          end;
      end
      else begin
          rpt.SelectPrinter(fDeviceName);
      end;
  end;

  Self.TitlePreview        :=fNFe.Id +'-nfe';
  Self.SystemPrinter.Title :=fNFe.Id +'-nfe';

  rpt.SetPaperSize(DMPAPER_A4, 0, 0);
  rpt.Orientation :=poPortrait;
  rpt.Copies      :=FCopies;
  //
  rpt.MarginTop    :=0.80;
  rpt.MarginBottom :=0.80;
  rpt.MarginLeft   :=0.80;
  rpt.MarginRight  :=0.80;
  //
  // colunas das fatura/duplicatas
  rpt.ClearTabs;
  rpt.SetTab(rpt.SectionLeft, pjLeft , WDUP_NRO  , 0, BOXLINENONE, 0);
  rpt.SetTab(NA             , pjLeft , WDUP_VENC , 0, BOXLINENONE, 0);
  rpt.SetTab(NA             , pjRight, WDUP_VALR , 0, BOXLINENONE, 0);
  //rpt.SetTab(NA             , pjLeft , WDUP_AGT  , 0, BOXLINENONE, 0);
  rpt.SaveTabs(7);

  rpt.ClearTabs;
  rpt.SetTab(10.50          , pjLeft , WDUP_NRO  , 0, BOXLINENONE, 0);
  rpt.SetTab(NA             , pjLeft , WDUP_VENC , 0, BOXLINENONE, 0);
  rpt.SetTab(NA             , pjRight, WDUP_VALR , 0, BOXLINENONE, 0);
  //rpt.SetTab(NA             , pjLeft , WDUP_AGT  , 0, BOXLINENONE, 0);
  rpt.SaveTabs(8);
  //
  // colunas dos produtos/serviços
  rpt.ClearTabs;
  rpt.SetTab(rpt.SectionLeft, pjCenter, WCODIGO_PRODUTO , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjLeft  , WDESCRI_PRODUTO , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjCenter, WNCM_SH         , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjCenter, WCST            , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjCenter, WCFOP           , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjCenter, WUNID           , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WQUANT          , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WVLR_UNIT       , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WVLR_TOT        , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WBC_ICMS        , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WVLR_ICMS       , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WVLR_IPI        , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WALIQ_ICMS      , 0, BOXLINELEFTRIGHT, 0);
  rpt.SetTab(NA             , pjRight , WALIQ_IPI       , 0, BOXLINELEFTRIGHT, 0);
  rpt.SaveTabs(9);

  // colunas dos produtos/serviços linhas adicional
  rpt.ClearTabs;
  rpt.SetTab(rpt.SectionLeft, pjCenter, WCODIGO_PRODUTO , 0, BOXLINELEFT	, 0);
  rpt.SetTab(NA							, pjLeft	, WLINEAD					, 0, BOXLINERIGHT	, 0);
  rpt.SaveTabs(10);
end;

procedure TnfeDanfe.DoPrint(Sender: TObject);
const HBOX = 0.85;
var rpt:RpBase.TBaseReport;
var x,y,h:Double;
var Itens:Integer;
var s:string;

    {$REGION 'PrintText'}
    procedure PrintText(const x, y: Double; const Text: string;
      const fName: string = FONT_TIMES_NW;
      const fSize: Double = FONT_SIZE_08 ;
      const fStyles: TFontStyles = [];
      const Just: TPrintJustify = pjLeft;
      const fColor: TColor = clWindowText;
      const Width: Double = 0.00);
    begin
        rpt.SetFont(fName, fSize);
        rpt.Bold      :=fsBold in fStyles;
        rpt.Italic    :=fsItalic in fStyles;
        rpt.Underline :=fsUnderline in fStyles;
        rpt.FontColor :=fColor;
        rpt.AdjustLine;
        rpt.GotoXY(x, y);
        case Just of
            pjLeft    : rpt.PrintLeft   (Text, x);
            pjCenter  : rpt.PrintCenter (Text, x);
            pjRight   : rpt.PrintRight  (Text, x);
            pjBlock   : rpt.PrintBlock  (Text, x, Width);
        end;
    end;
    {$ENDREGION}

    {$REGION 'DrawBox'}
    procedure DrawBox(const x1, y1, x2, y2: Double;
      const caption:string='';
      const text:string='';
      const just:TPrintJustify=pjLeft;
      const color:TColor=clWindowText);
    var str:TStrings;
    var p,c:Double;
    var i:Integer;
    var m:TMemoBuf;
    var mtd:TLineHeightMethod ;
    begin
        p :=0;
        rpt.Rectangle(x1, y1, x2, y2);
        if caption<>'' then
        begin
          if Pos('","',caption)>0 then
          begin
            c :=0.20;
            str :=TStringList.Create;
            str.CommaText :=caption;
            for i :=0 to str.Count -1 do
            begin
                s :=Trim(str.Strings[i]);
                case just of
                  pjLeft    :PrintText(x1+0.10      ,y1+c,s,FONT_TIMES_NW,FONT_SIZE_06);
                  pjCenter  :PrintText(x1+(x2-x1)/2 ,y1+c,s,FONT_TIMES_NW,FONT_SIZE_06,[],pjCenter);
                  pjRight   :PrintText(x2-0.10      ,y1+c,s,FONT_TIMES_NW,FONT_SIZE_06,[],pjRight);
                end;
                c:=c+0.20;
            end;
            str.Free;
          end
          else begin
            PrintText(x1+0.10, y1+0.20, Trim(caption), FONT_TIMES_NW, FONT_SIZE_06);
          end;
        end;
        //
        if text<>'' then
        begin
          rpt.SetFont(FONT_TIMES_NW, FONT_SIZE_10);
          rpt.AdjustLine;
          if rpt.TextWidth(text) > (x2-x1) then
          begin

              mtd :=rpt.LineHeightMethod  ;
              rpt.LineHeightMethod :=lhmLinesPerInch;
              rpt.LinesPerInch:=9;
              rpt.YPos :=y1 +0.50;
              m :=TMemoBuf.Create;
              try
                  m.BaseReport  :=rpt;
                  m.Text        :=text;
                  m.PrintStart  :=x1+0.10;
                  m.PrintEnd    :=x2-0.10;
                  m.PrintLines(2, False);
              finally
                  m.Free;
                  rpt.LineHeightMethod :=mtd  ;
                  rpt.LinesPerInch:=6;
              end;
          end
          else begin
              case just of
                pjLeft  : p :=x1 + 0.10;
                pjCenter: begin
                    p :=(x2 - x1)/2;
                    p :=x1 + p;
                end;
                pjRight : p :=x2 - 0.10;
              end;
              PrintText(p, y2-0.10, text, FONT_TIMES_NW, FONT_SIZE_10, [], just, color);
          end;
        end;
    end;
    {$ENDREGION}

    {$REGION 'DrawLine'}
    procedure DrawLine(const x1, y1, x2, y2: Double; pen:TPenStyle = psSolid);
    begin
        rpt.MoveTo(x1, y1);
        rpt.SetPen(clWindowText, pen, 1, pmCopy);
        rpt.LineTo(x2, y2);
        rpt.SetPen(clWindowText, psSolid, 1, pmCopy);
    end;
    {$ENDREGION}

    {$REGION 'PrintBarCod128'}
    procedure PrintBarCod128(x, y: Double; codigo: string);
    var Cod128: TRPBarsCode128;
    begin
        Cod128  :=TRPBarsCode128.Create(rpt);
        try
          Cod128.BarHeight :=1.0;
          Cod128.BarWidth  :=0.023;
          Cod128.WideFactor:=0.025;
          Cod128.PrintReadable:=False;
          Cod128.CodePage  :=cpCodeC;
          Cod128.Text      :=codigo;
          Cod128.PrintXY(x, y);
        finally
          Cod128.Free;
        end;
    end;
    {$ENDREGION}

    {$REGION 'DoCab'}
    procedure DoCab;
    var
        xnome: string;
        local: string ;
    var
        m:TMemoBuf;
        x0,y0:Double  ;
    begin
        xnome	:=Tnfeutil.ParseText(fNFe.emit.xNome, True);
        local :=Tnfeutil.ParseText(fNFe.emit.ender.xLgr	 , True) +#13;
        local :=local +Tnfeutil.ParseText(fNFe.emit.ender.xBairro, True) +#13;
        local :=local +Tnfeutil.ParseText(fNFe.emit.ender.xMun	 , True) +'-';
        local :=local +fNFe.emit.ender.UF +#13	;

        if fNFe.emit.ender.CEP<>'' then
        begin
            local :=local +Tnfeutil.FormatCEP(fNFe.emit.ender.CEP);
        end;
        if fNFe.emit.ender.fone<>'' then
        begin
            local :=local +#13+ Tnfeutil.FormatFone(fNFe.emit.ender.fone) ;
        end;

        // quadro identificação do emitente
        DrawBox(x, y, x +10, y+3.92, 'IDENTIFICAÇÃO DO EMITENTE');
        rpt.SetFont(FONT_TIMES_NW, FONT_SIZE_12); rpt.AdjustLine ; rpt.Bold :=True;
        x0 :=x ;
        y0 :=y ;
        if rpt.TextWidth(xnome)>10 then
        begin
            rpt.GotoXY(x, y+0.80);
            m :=TMemoBuf.Create;
            try
                m.BaseReport  :=rpt;
                m.Text        :=xnome;
                m.PrintStart  :=x +0.10;
                m.PrintEnd    :=x +9.90;
                m.PrintLines(2, False);
            finally
                m.Free;
            end;
            y :=y +rpt.LineHeight ;
        end
        else
        begin
            PrintText(x+5.0, y+0.80, xnome, FONT_TIMES_NW, FONT_SIZE_12, [fsBold], pjCenter);
        end;

        rpt.GotoXY(x+3.0, y+1.50);
        m :=TMemoBuf.Create;
        try
            rpt.SetFont(FONT_TIMES_NW, FONT_SIZE_10); rpt.AdjustLine ; rpt.Bold :=False;
            m.BaseReport  :=rpt;
            m.Text        :=local ;
            m.PrintStart  :=x +3.00;
            m.PrintEnd    :=x +9.90;
            m.PrintLines(0, False);
        finally
            m.Free;
        end;

        x :=x0;
        y :=y0;

        // logo
        if Assigned(fBitmap) then
        begin
            rpt.StretchDraw(rpt.CreateRect(x +0.10, y +1.20, x +2.80, y +2.40), fBitmap);
        end;

        // quadro identificação do documento
        x :=x+10;
        DrawBox(x, y, x +2.54, y+3.92);
        PrintText(x+1.27, y+0.40, 'DANFE'      , FONT_TIMES_NW, FONT_SIZE_12, [fsBold], pjCenter);
        PrintText(x+1.27, y+0.80, 'DOCUMENTO'  , FONT_TIMES_NW, FONT_SIZE_08, [], pjCenter);
        PrintText(x+1.27, y+1.10, 'AUXILIAR DA', FONT_TIMES_NW, FONT_SIZE_08, [], pjCenter);
        PrintText(x+1.27, y+1.40, 'NOTA FISCAL', FONT_TIMES_NW, FONT_SIZE_08, [], pjCenter);
        PrintText(x+1.27, y+1.70, 'ELETRÔNICA'	, FONT_TIMES_NW, FONT_SIZE_08, [], pjCenter);
        PrintText(x+0.15, y+2.10, '0-ENTRADA'  );
        PrintText(x+0.15, y+2.40, '1-SAIDA'    );
        DrawBox(x+1.90, y+1.90, x+2.40, y+2.40);
        PrintText(x+2.10, y+2.30, IntToStr(Ord(fNFe.ide.tpNF)), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
        PrintText(x+0.15, y+2.90, 'Nº:');
        PrintText(x+0.60, y+2.90, Tnfeutil.FormatDocFiscal(fNFe.ide.nNF), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
        PrintText(x+0.60, y+3.20, 'SÉRIE:');
        PrintText(x+1.60, y+3.20, Tnfeutil.FInt(fNFe.ide.serie, 3), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
        PrintText(x+0.60, y+3.50, 'FOLHA:');
        PrintText(x+1.60, y+3.50, rpt.Macro(midCurrentPage) +'/'+ rpt.Macro(midTotalPages), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);

        // quadro codigo de barras da chave
        x :=x +2.54;
        DrawBox(x, y, rpt.SectionRight, y+1.48);
        PrintBarCod128(x+0.15, y+0.15, fNFe.Id);

        // quadro chave de acesso
        y :=y+1.48;
        s :=Tnfeutil.Ch_Format(fNFe.Id);
        DrawBox(x, y, rpt.SectionRight, y+0.96, 'CHAVE DE ACESSO');
        PrintText(x+0.10, y+0.55, Copy(s,01,40), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
        PrintText(x+0.10, y+0.85, Copy(s,41,14), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);

        // quadro codigo de barras dos dados
        y :=y+0.96;
        DrawBox(x, y, rpt.SectionRight, y+1.48);
        if fNFe.ide.tpEmis = emisCon_FS then
        begin
            s :=IntToStr(fNFe.ide.cUF);
            s :=s + IntToStr(Ord(fNFe.ide.tpEmis)+1);
            s :=s + fNFe.emit.CNPJ;
            s :=s + Tnfeutil.PadD(Tnfeutil.FFlt(fNFe.total.vNF*100,'0'),14,'0');
            if fNFe.total.vICMS > 0 then
            begin
                s :=s + '1'; // há destaque de ICMS próprio
            end
            else begin
                s :=s + '2'; // não há destaque de ICMS próprio
            end;
            if fNFe.total.vST > 0 then
            begin
                s :=s + '1';  // há destaque de ICMS por substituição tributária
            end
            else begin
                s :=s + '2';  // não há destaque de ICMS por substituição tributária
            end;
            s :=s +FormatDateTime('dd',fNFe.ide.dEmi);
            s :=s +IntToStr(Tnfeutil.Mod11(s));
            PrintBarCod128(x+0.15, y+0.15, s);
        end
        else begin
            PrintText(x+0.15, y+0.25, 'Consulta de autenticidade no portal nacional da NF-e');
            PrintText(x+0.15, y+0.50, 'www.nfe.fazenda.gov.br/portal');
            PrintText(x+0.15, y+0.75, 'ou no site da SEFAZ autorizadora');
        end;

        // quadro natureza da operação
        x :=rpt.SectionLeft;
        y :=y+1.48;
        DrawBox(x, y, x+12.54, y+HBOX, 'NATUREZA DA OPERAÇÃO', fNFe.ide.natOp);

        // quadro dados da NF-e
        x :=x+12.54;
        if fNFe.ide.tpEmis = emisCon_FS then
        begin
            s :=Tnfeutil.Ch_Format(s,36);
            DrawBox(x, y, rpt.SectionRight, y+HBOX, 'DADOS DA NF-e');
            PrintText(x+0.10, y+0.50, Copy(s,01,40), FONT_TIMES_NW, FONT_SIZE_10);//, [fsBold]);
            PrintText(x+0.10, y+0.80, Copy(s,41,14), FONT_TIMES_NW, FONT_SIZE_10);//, [fsBold]);
        end
        else begin
            if finfProt=nil then  s :=''
            else                  s :=finfProt.nProt +'  '+ Tnfeutil.FDat(finfProt.dhRecbto,dpDateTime);
            DrawBox(x, y, rpt.SectionRight, y+HBOX, 'PROTOCOLO DE AUTORIZAÇÃO DE USO',s);
        end;
        x :=rpt.SectionLeft;
        y :=y +HBOX;
        rpt.GotoXY(x, y);

    end;
    {$ENDREGION}

    {$REGION 'DoDestRem'}
    procedure DoDestRem;
    var cnpj,cpf:string;
        nome: string;
        logr: string;
        bair: string;
        muni: string;
        uf: string;
        cep: string;
        fone: string;
    begin
        cnpj  :=fNFe.dest.CNPJ;
        cpf   :=fNFe.dest.CPF;;
        nome  :=Tnfeutil.ParseText(fNFe.dest.xNome						, True);
        logr  :=Tnfeutil.ParseText(fNFe.dest.ender.xLgr		, True);
        bair  :=Tnfeutil.ParseText(fNFe.dest.ender.xBairro, True);
        muni  :=Tnfeutil.ParseText(fNFe.dest.ender.xMun		, True);
        uf	  :=fNFe.dest.ender.UF	;
        cep	  :=fNFe.dest.ender.CEP	;
        fone  :=fNFe.dest.ender.fone;

        y :=y +0.30;
        PrintText(x, y, 'DESTINATÁRIO REMETENTE', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
        if cnpj<>'' then
        begin
            DrawBox(x      , y+0.10, x +12.54, y +0.10+HBOX, 'RAZÃO SOCIAL', nome);
            DrawBox(x+12.54, y+0.10, x +16.50, y +0.10+HBOX, 'C.N.P.J.'    , Tnfeutil.FormatCNPJ(cnpj));
        end
        else
        begin
            DrawBox(x      , y+0.10, x +12.54, y +0.10+HBOX, 'NOME', nome);
            DrawBox(x+12.54, y+0.10, x +16.50, y +0.10+HBOX, 'C.P.F.', Tnfeutil.FormatCPF(cpf));
        end;

//        DrawBox(x, y+0.10, x +12.54, y +0.10+HBOX, 'NOME / RAZÃO SOCIAL', nome);
//        if Length(cnpj_cpf) >= 14 then
//        begin
//          s :=Tnfeutil.FormatCNPJ(cnpj_cpf);
//        end
//        else begin
//          s :=Tnfeutil.FormatCPF(cnpj_cpf);
//        end;
//        DrawBox(x+12.54, y+0.10, x +16.50         , y +0.10+HBOX, 'C.N.P.J./C.P.F.', s);

        DrawBox(x+16.50, y+0.10, rpt.SectionRight , y +0.10+HBOX, 'DATA DA EMISSÃO', Tnfeutil.FDat(fNFe.ide.dEmi));
        y :=y +0.10 +HBOX;
        DrawBox(x       , y, x +10.00        , y +HBOX, 'ENDEREÇO'              , logr);
        DrawBox(x+10.00 , y, x +14.83        , y +HBOX, 'BAIRRO / DISTRITO'     , bair);
        DrawBox(x+14.83 , y, x +16.50        , y +HBOX, 'CEP'                   , Tnfeutil.FormatCEP(cep));
        DrawBox(x+16.50 , y, rpt.SectionRight, y +HBOX, 'DATA DA ENTRADA/SAIDA' , Tnfeutil.FDat(fNFe.ide.dSaiEnt));
        y :=y +HBOX;
        DrawBox(x				, y, x +07.11        , y +HBOX, 'MUNICÍPIO						 ', muni);
        DrawBox(x+07.11	, y, x +11.11        , y +HBOX, 'FONE / FAX						', Tnfeutil.FormatFone(fone));
        DrawBox(x+11.11	, y, x +12.11        , y +HBOX, 'UF										', uf);
        if fNFe.dest.IE<>'ISENTO' then
        begin
            DrawBox(x+12.11	, y, x +16.50				 , y +HBOX, 'INSCRIÇÃO ESTADUAL		', Tnfeutil.FormatIE(fNFe.dest.IE,fNFe.dest.ender.UF));
        end
        else
        begin
            DrawBox(x+12.11	, y, x +16.50				 , y +HBOX, 'INSCRIÇÃO ESTADUAL		', fNFe.dest.IE);
        end;
        DrawBox(x+16.50	, y, rpt.SectionRight, y +HBOX, 'HORA DA ENTRADA/SAIDA', Tnfeutil.FDat(fNFe.ide.hSaiEnt,dpTime));
        x :=rpt.SectionLeft;
        y :=y +HBOX;
        rpt.GotoXY(x, y);
    end;
    {$ENDREGION}

    {$REGION 'DoDup'}
    procedure DoDup;
    var dup: TdupList.Tdup;
    var FDupNum,FDupVenc,FDupVal: string;
    var I,T: Integer;
    begin
        Itens :=Tnfeutil.SeSenao(fNFe.ide.tpEmis=emisCon_FS,25,26);
        y :=y +0.30;
        PrintText(x, y, 'FATURA / DUPLICATAS', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
        //DrawBox(x, y+0.05, rpt.SectionRight, y +0.20+HBOX);
        rpt.GotoXY(x, y); //rpt.GotoXY(x, y +0.10);
        rpt.SetFont(FONT_COURIER_NW, FONT_SIZE_08);
        rpt.AdjustLine;
        rpt.LineHeightMethod :=lhmLinesPerInch;
        rpt.LinesPerInch :=8;

        h :=y; // rpt.YPos +rpt.FontHeight; //-0.10;//0.15;
        rpt.GotoXY(x, h);
        T :=fNFe.cobr.dup.Count;
        if T <= 3 then T :=3;
        if T > 3  then T :=6;

        for i :=0 to T -1 do
        begin
          if i < fNFe.cobr.dup.Count then
          begin
            dup :=fNFe.cobr.dup.Items[i];
            FDupNum :='Número: '+ dup.nDup;
            FDupVenc:='Dt.Venc: '+ Tnfeutil.FDat(dup.dVenc);
            FDupVal :='Valor: '+Tnfeutil.FCur(dup.vDup);
          end
          else begin
            FDupNum :='';
            FDupVenc:='';
            FDupVal :='';
          end;

          if Odd(i) then
          begin
            rpt.TabShade :=15;
          end
          else begin
            rpt.TabShade :=0;
          end;

          if i < 3 then
          begin
            rpt.NewLine;
            rpt.RestoreTabs(7);
            if i = 0 then
            begin
              rpt.PrintTab(1, FDupNum , BOXLINELEFTTOP);
              rpt.PrintTab(2, FDupVenc, BOXLINETOP);
              rpt.PrintTab(3, FDupVal , BOXLINERIGHTTOP);
            end
            else begin
              if i = 2 then
              begin
                rpt.PrintTab(1, FDupNum , BOXLINELEFTBOTTOM);
                rpt.PrintTab(2, FDupVenc, BOXLINEBOTTOM);
                rpt.PrintTab(3, FDupVal , BOXLINERIGHTBOTTOM);
              end
              else begin
                rpt.PrintTab(1, FDupNum , BOXLINELEFT);
                rpt.PrintTab(2, FDupVenc, BOXLINENONE);
                rpt.PrintTab(3, FDupVal , BOXLINERIGHT);
              end;
            end;
          end
          else begin
            if i = 3 then
            begin
              rpt.GotoXY(x, h);
            end;
            rpt.NewLine;
            rpt.RestoreTabs(8);
            if i = 3 then
            begin
              rpt.PrintTab(1, FDupNum , BOXLINELEFTTOP);
              rpt.PrintTab(2, FDupVenc, BOXLINETOP);
              rpt.PrintTab(3, FDupVal , BOXLINERIGHTTOP);
            end
            else begin
              if i = 5 then
              begin
                rpt.PrintTab(1, FDupNum , BOXLINELEFTBOTTOM);
                rpt.PrintTab(2, FDupVenc, BOXLINEBOTTOM);
                rpt.PrintTab(3, FDupVal , BOXLINERIGHTBOTTOM);
              end
              else begin
                rpt.PrintTab(1, FDupNum , BOXLINELEFT);
                rpt.PrintTab(2, FDupVenc, BOXLINENONE);
                rpt.PrintTab(3, FDupVal , BOXLINERIGHT);
              end;
            end;
          end;
        end;
        rpt.LineHeightMethod :=lhmFont;
        rpt.LinesPerInch :=6;
    end;
    {$ENDREGION}

    {$REGION 'DoCabProd'}
    procedure DoCabProd;
    begin
        y :=y     +0.30;
        h :=HBOX  -0.10;
        PrintText(x, y, 'DADOS DOS PRODUTOS / SERVIÇOS', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
        DrawBox(x, y+0.10, x +WCODIGO_PRODUTO , y +h, '"CODIGO","PRODUTO"','',pjCenter); x :=x +WCODIGO_PRODUTO;
        DrawBox(x, y+0.10, x +WDESCRI_PRODUTO , y +h, 'DESCRIÇÃO DO PRODUTO / SERVIÇO'); x :=x +WDESCRI_PRODUTO;
        DrawBox(x, y+0.10, x +WNCM_SH         , y +h, 'NCM/SH'                        ); x :=x +WNCM_SH;
        DrawBox(x, y+0.10, x +WCST            , y +h, 'CST'                           ); x :=x +WCST;
        DrawBox(x, y+0.10, x +WCFOP           , y +h, 'CFOP'                          ); x :=x +WCFOP;
        DrawBox(x, y+0.10, x +WUNID           , y +h, 'UN'                            ); x :=x +WUNID;
        DrawBox(x, y+0.10, x +WQUANT          , y +h, 'QUANT'                         ,'',pjCenter); x :=x +WQUANT;
        DrawBox(x, y+0.10, x +WVLR_UNIT       , y +h, '"VALOR","UNITÁRIO"'            ,'',pjCenter); x :=x +WVLR_UNIT;
        DrawBox(x, y+0.10, x +WVLR_TOT        , y +h, '"VALOR","TOTAL"'               ,'',pjCenter); x :=x +WVLR_TOT;
        DrawBox(x, y+0.10, x +WBC_ICMS        , y +h, '"B.CÁCULO","DO ICMS"'          ,'',pjCenter); x :=x +WBC_ICMS;
        DrawBox(x, y+0.10, x +WVLR_ICMS       , y +h, '"VALOR DO","ICMS"'             ,'',pjCenter); x :=x +WVLR_ICMS;
        DrawBox(x, y+0.10, x +WVLR_IPI        , y +h, '"VALOR","IPI"'                 ,'',pjCenter); x :=x +WVLR_IPI;
        DrawBox(x, y+0.10, x +WALIQ_ICMS      , y +h, '"ALÍQ.","ICMS"'                ,'',pjCenter); x :=x +WALIQ_ICMS;
        DrawBox(x, y+0.10, x +WALIQ_IPI       , y +h, '"ALÍQ.","IPI"'                 ,'',pjCenter);
        x :=rpt.SectionLeft;
        y :=y +h;
        rpt.GotoXY(x, y);
    end;
    {$ENDREGION}

    {$REGION 'DoInfoAdic'}
    procedure DoInfoAdic;
    var obs:TobsContList.TobsCont;
    var m:TMemoBuf;
    var i:string ;
    var c:Integer;
		var contData: TDateTime ;
    		contJust: string ;
    begin
        y :=y +0.30;
        h	:=y +3.17;
        PrintText(x, y, 'DADOS ADICIONAIS', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
        DrawBox(x       , y+0.10, x +12.95        , h, 'INFORMAÇÕES COMPLEMENTARES','WWW.SUPORTWARE.COM.BR',pjCenter,clSilver);
        DrawBox(x +12.95, y+0.10, rpt.SectionRight, h, 'RESERVADO AO FISCO'         );

        x :=x +0.10;
        y :=y +0.70;

        {if fNFe.infAdic.obsCont.Count>0 then
        begin
            for c :=0 to fNFe.infAdic.obsCont.Count -1 do
            begin
                obs :=fNFe.infAdic.obsCont.Items[c];
                obs.xTexto :=Tnfeutil.ParseText(obs.xTexto,True) ;
                if Tnfeutil.IsEmpty(obs.xTexto) then
                  Continue
                else begin
                  PrintText(x, y, obs.xTexto, FONT_COURIER_NW, FONT_SIZE_08);
                  y :=y +rpt.FontHeight;
                end;
            end;
        end;}

        if fNFe.infAdic.infCpl<>'' then
        begin
            i :=Tnfeutil.ParseText(fNFe.infAdic.infCpl,True)	;
            for c :=1 to Length(i) do
            begin
                if i[c]=';' then
                begin
                    i[c]:=#13	;
                end;
            end;

//            PrintText(x, y, fNFe.infAdic.infCpl, FONT_COURIER_NW, FONT_COURIER_NW_08);
            rpt.SetFont(FONT_COURIER_NW, FONT_SIZE_08);
            rpt.AdjustLine;
            rpt.GotoXY(x, y);
            m	:=TMemoBuf.Create;
            try
//                rpt.LineHeightMethod :=lhmFont;
                m.BaseReport  :=rpt;
                m.Text        :=i;
                m.PrintStart  :=x;
                m.PrintEnd    :=x +12.85;
                m.PrintLines(0, False);
            finally
//              	rpt.LineHeightMethod :=lhmLinesPerInch;
                m.Free;
            end;
        end;

        // msg contingência
        if fNFe.ide.tpEmis = emisCon_FS then
        begin
            x :=rpt.SectionLeft;
            y :=h -rpt.LineHeight	;
            rpt.GotoXY(	x+0.10, y);

            s :=FormatDateTime('"Contingência: "dd/mm/yyyy hh:nn:ss',fNFe.ide.dhCont);
            s :=Format('%s-%s',[s,fNFe.ide.xJust]) ;
            PrintText	(x, y, s, FONT_COURIER_NW, FONT_SIZE_08);

            y :=h +0.30;
            rpt.GotoXY(	x, y);
            PrintText	(	x, y,
                        'DANFE em contingência, impresso em decorrência de problemas técnicos!',
                        FONT_TIMES_NW,
                        FONT_SIZE_10,
                        [fsBold]);
            y :=y +0.25;
        end
        else begin
            y :=h +0.30;
        end;
        x:=(rpt.SectionRight -rpt.SectionLeft)/2;
        x:=rpt.SectionLeft + x;
        rpt.GotoXY(	x, y);
        PrintText	(	x, y,
                    NFE_TIPO_AMB[fNFe.ide.tpAmb],
                    FONT_TIMES_NW,
                    FONT_SIZE_06,
                    [fsBold],
                    pjCenter);
    end;
    {$ENDREGION}

var i,l,c:Integer;
var pro: TnfeProduto; // Tprod;
var imp: TnfeImposto; // Timposto;
var det: TnfeDet;

var CST:string;
var vBC:Currency	;
var pICMS:Currency;
var vICMS:Currency;
var vIPI,pIPI:Currency;

begin
    //

    rpt	:=Self.BaseReport; //(Sender as TBaseReport) ;
    // quadro canhoto
    s :=Format('RECEBEMOS DE (%s OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO)',[Tnfeutil.ParseText(fNFe.emit.xNome,True)]);
    x :=rpt.SectionLeft;
    y :=rpt.SectionTop;

    DrawBox(x       , y         , x+16.10 , y + HBOX    , s                                        );
    DrawBox(x       , y + HBOX  , x+04.10 , y + 2*HBOX  , 'DATA DE RECEBIMENTO'                    );
    DrawBox(x+04.10 , y + HBOX  , x+16.10 , y + 2*HBOX  , 'IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR');
    DrawBox(x+16.10 , y         , rpt.SectionRight      , y + 2*HBOX );

    PrintText(x+16.25, y+0.40, 'NF-e', FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
    PrintText(x+16.25, y+0.80, 'Nº: '+Tnfeutil.FormatDocFiscal(fNFe.ide.nNF), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);
    PrintText(x+16.25, y+1.20, 'SÉRIE: '+Tnfeutil.FInt(fNFe.ide.serie, 3), FONT_TIMES_NW, FONT_SIZE_10, [fsBold]);

    x :=rpt.SectionLeft;
    y :=y + 2*HBOX +0.15;
    rpt.GotoXY(x, y);

    DrawLine(00.00, y, 21.00, y, psDashDotDot);

    y :=y + 0.15;
    rpt.GotoXY(x, y);

    // cabeçalho
    DoCab;

    // inscrição estadual / insc. est. subst. tributário / cnpj

    DrawBox(x       , y, x +6.86          , y +HBOX, 'INSCRIÇÃO ESTADUAL' , Tnfeutil.FormatIE(fNFe.emit.IE,fNFe.emit.ender.UF));
    DrawBox(x +06.86, y, x +13.72         , y +HBOX, 'INSC. EST. SUBST. TRIBUTÁRIO');
    DrawBox(x +13.72, y, rpt.SectionRight , y +HBOX, 'C.N.P.J.'           , Tnfeutil.FormatCNPJ(fNFe.emit.CNPJ));
    x :=rpt.SectionLeft;
    y :=y +HBOX;
    rpt.GotoXY(x, y);

    // quadro dest. remetente
    DoDestRem ;

    Itens :=30;
    // quadro fatura / duplicatas
    if fNFe.cobr.dup.Count > 0 then
    begin
        DoDup;
        x :=rpt.SectionLeft;
        y :=y +0.10+HBOX;
        rpt.GotoXY(x, y);
        rpt.TabShade :=0;
        rpt.SetFont(FONT_COURIER_NW, FONT_SIZE_10);
        rpt.AdjustLine;
    end;

    // quadro calc. do imposto
    y :=y +0.30;
    PrintText(x, y, 'CALCULO DO IMPOSTO', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
    DrawBox(x       , y+0.10, x +4.06         , y +0.10+HBOX, 'BASE DE CÁLCULO DO ICMS		', Tnfeutil.FCur(fNFe.total.vBC  ), pjRight);
    DrawBox(x +04.06, y+0.10, x +08.12        , y +0.10+HBOX, 'VALOR DO ICMS						 ', Tnfeutil.FCur(fNFe.total.vICMS), pjRight);
    DrawBox(x +08.12, y+0.10, x +12.18        , y +0.10+HBOX, 'BASE DE CÁLCULO DO ICMS ST', Tnfeutil.FCur(fNFe.total.vBCST), pjRight);
    DrawBox(x +12.18, y+0.10, x +16.24        , y +0.10+HBOX, 'VALOR DO ICMS ST          ', Tnfeutil.FCur(fNFe.total.vST  ), pjRight);
    DrawBox(x +16.24, y+0.10, rpt.SectionRight, y +0.10+HBOX, 'VALOR TOT. DOS PRODUTOS   ', Tnfeutil.FCur(fNFe.total.vProd), pjRight);
    y :=y +0.10+HBOX;
    DrawBox(x       , y, x +03.30         , y +HBOX, 'VALOR DO FRETE	         ', Tnfeutil.FCur(fNFe.total.vFrete	), pjRight);
    DrawBox(x +03.30, y, x +06.60         , y +HBOX, 'VALOR DO SEGURO	         ', Tnfeutil.FCur(fNFe.total.vSeg		), pjRight);
    DrawBox(x +06.60, y, x +09.90         , y +HBOX, 'DESCONTO				         ', Tnfeutil.FCur(fNFe.total.vDesc		), pjRight);
    DrawBox(x +09.90, y, x +13.20         , y +HBOX, 'OUT. DESPESAS ACESSÓRIAS	', Tnfeutil.FCur(fNFe.total.vOutro	 ), pjRight);
    DrawBox(x +13.20, y, x +16.24         , y +HBOX, 'VALOR IPI								 ', Tnfeutil.FCur(fNFe.total.vIPI		), pjRight);
    DrawBox(x +16.24, y, rpt.SectionRight , y +HBOX, 'VALOR TOTAL DA NOTA			 ', Tnfeutil.FCur(fNFe.total.vNF			), pjRight);
    x :=rpt.SectionLeft;
    y :=y +HBOX;
    rpt.GotoXY(x, y);

    // quadro transp/volumes transportados
    y :=y +0.30;
    case fNFe.transp.modFrete of
        freEmit:s :='0-Emitente'	;
        freDest:s :='1-Dest/Rem'	;
        freTerc:s :='2-Terceiros'	;
    else
      	s :='9-Sem Frete'	;
    end;
    PrintText(x, y, 'TRANSPORTADOR / VOLUMES TRANSPORTADOS', FONT_TIMES_NW, FONT_SIZE_06, [fsBold]);
    DrawBox(x, y+0.10, x +09.02, y +0.10+HBOX, 'NOME / RAZÃO SOCIAL', Tnfeutil.ParseText(fNFe.transp.transporta.xNome,True));
    DrawBox(x +09.02, y+0.10, x +11.81, y +0.10+HBOX, 'FRETE POR CONTA DE',S);
    DrawBox(x +11.81, y+0.10, x +13.59, y +0.10+HBOX, 'CÓDIGO ANTT');
    DrawBox(x +13.59, y+0.10, x +15.48, y +0.10+HBOX, 'PLACA VEÍCULO', fNFe.transp.veicTransp.placa);
    DrawBox(x +15.48, y+0.10, x +16.24, y +0.10+HBOX, 'UF', fNFe.transp.veicTransp.UF);
    if fNFe.transp.transporta.CNPJ<>'' then
    begin
        DrawBox(x +16.24, y+0.10, rpt.SectionRight, y +0.10+HBOX, 'C.N.P.J.', Tnfeutil.FormatCNPJ(fNFe.transp.transporta.CNPJ));
    end
    else begin
        DrawBox(x +16.24, y+0.10, rpt.SectionRight, y +0.10+HBOX, 'C.P.F.', Tnfeutil.FormatCPF(fNFe.transp.transporta.CPF));
    end;
    y :=y +0.10+HBOX;
    DrawBox(x, y, x +09.02, y +HBOX, 'ENDEREÇO', Tnfeutil.ParseText(fNFe.transp.transporta.xEnder,True));
    DrawBox(x +09.02, y, x +15.48, y +HBOX, 'MUNICÍPIO', Tnfeutil.ParseText(fNFe.transp.transporta.xMun,True));
    DrawBox(x +15.48, y, x +16.24, y +HBOX, 'UF', fNFe.transp.transporta.UF);
    DrawBox(x +16.24, y, rpt.SectionRight, y +HBOX, 'INSCRIÇÃO ESTADUAL', Tnfeutil.FormatIE(fNFe.transp.transporta.IE,fNFe.transp.transporta.UF));
    y :=y +HBOX;
    DrawBox(x				, y, 				 x +02.92, y +HBOX, 'QUANTIDADE DE VOLUMES'	, Tnfeutil.FFlt(fNFe.transp.vol.qVol,'0')		 , pjRight);
    DrawBox(x +02.92, y,         x +05.97, y +HBOX, 'ESPÉCIE							 ' , fNFe.transp.vol.esp			                                   );
    DrawBox(x +05.97, y,         x +09.02, y +HBOX, 'MARCA								'	, fNFe.transp.vol.marca		                                    );
    DrawBox(x +09.02, y,         x +13.85, y +HBOX, 'NUMERAÇÃO						');
    DrawBox(x +13.85, y,         x +17.28, y +HBOX, 'PESO BRUTO						'	, Tnfeutil.FFlt(fNFe.transp.vol.pesoB,'0.000'),pjRight);
    DrawBox(x +17.28, y, rpt.SectionRight, y +HBOX, 'PESO LÍQUIDO				 ' , Tnfeutil.FFlt(fNFe.transp.vol.pesoL,'0.000'),pjRight);
    x :=rpt.SectionLeft;
    y :=y +HBOX;
    rpt.GotoXY(x, y);

    // quadro dados dos produtos / serviços
    DoCabProd;
    rpt.SetFont(FONT_COURIER_NW, FONT_SIZE_06);
    rpt.AdjustLine;
    c :=0;
    for i :=0 to fNFe.det.Count -1 do
    begin
        vBC 	:=0;
        pICMS :=0;
        vICMS :=0;

        det :=fNFe.det.Items[I] ;
        pro :=det.prod;
        imp :=det.imposto;

        //CST   :=Tnfeutil.FInt(Ord(imp.ICMS.CST));
        CST   :=IntToStr(Ord(imp.ICMS.orig)) + Tnfeutil.FInt(Ord(imp.ICMS.CST));
        vBC		:=imp.ICMS.vBC	;
        pICMS :=imp.ICMS.pICMS;
        vICMS :=imp.ICMS.vICMS;
        vIPI  :=imp.IPI.vIPI ;
        pIPI  :=imp.IPI.pIPI ;

        {case imp.ICMS.icmsst of
            icmsst00: begin
                        CST   :=Tnfeutil.FInt(imp.ICMS.ICMS00.CST);
                        vBC		:=imp.ICMS.ICMS00.vBC	;
                        pICMS :=imp.ICMS.ICMS00.pICMS;
                        vICMS :=imp.ICMS.ICMS00.vICMS;
                      end;
            icmsst10: begin
                        CST   :=Tnfeutil.FInt(imp.ICMS.ICMS10.CST);
                        vBC		:=imp.ICMS.ICMS10.vBC	;
                        pICMS :=imp.ICMS.ICMS10.pICMS;
                        vICMS :=imp.ICMS.ICMS10.vICMS;
                      end;
            icmsst20: begin
                        CST   :=Tnfeutil.FInt(imp.ICMS.ICMS20.CST);
                        vBC		:=imp.ICMS.ICMS20.vBC	;
                        pICMS :=imp.ICMS.ICMS20.pICMS;
                        vICMS :=imp.ICMS.ICMS20.vICMS;
                      end;
            icmsst30: CST :=Tnfeutil.FInt(imp.ICMS.ICMS30.CST);
            icmsst40: CST :=Tnfeutil.FInt(imp.ICMS.ICMS40.CST);
            icmsst51: begin
                        CST   :=Tnfeutil.FInt(imp.ICMS.ICMS51.CST);
                        vBC		:=imp.ICMS.ICMS51.vBC	;
                        pICMS :=imp.ICMS.ICMS51.pICMS;
                        vICMS :=imp.ICMS.ICMS51.vICMS;
                      end;
            icmsst60: CST :=Tnfeutil.FInt(imp.ICMS.ICMS60.CST);
            icmsst70: begin
                        CST   :=Tnfeutil.FInt(imp.ICMS.ICMS70.CST);
                        vBC		:=imp.ICMS.ICMS70.vBC;
                        pICMS :=imp.ICMS.ICMS70.pICMS;
                        vICMS :=imp.ICMS.ICMS70.vICMS;
                      end;
        else
            CST 	:=Tnfeutil.FInt(imp.ICMS.ICMS90.CST);
            vBC		:=imp.ICMS.ICMS90.vBC;
            pICMS :=imp.ICMS.ICMS90.pICMS;
            vICMS :=imp.ICMS.ICMS90.vICMS;
        end;}

        // quebra de pag
        if (c=Itens) then
        begin
            x :=rpt.SectionLeft;
            y :=rpt.YPos +0.05 ;
            rpt.GotoXY(x, y);
            //
            DoInfoAdic;
            //
            PrintText(rpt.SectionRight, y, 'CONTINUA NO VERSO', FONT_TIMES_NW, FONT_SIZE_10, [], pjRight);
            rpt.NewPage;
            //
            x :=rpt.SectionLeft ;
            y :=rpt.SectionTop  ;
            rpt.GotoXY(x, y);
            //
            DoCab;
            DoCabProd;
            rpt.SetFont(FONT_COURIER_NW, FONT_SIZE_06);
            rpt.AdjustLine;
            //
            c     :=0;
            Itens :=Tnfeutil.SeSenao(fNFe.ide.tpEmis=emisCon_FS,72,73);
        end;

        rpt.NewLine; Inc(c);
        rpt.RestoreTabs(9);
        rpt.PrintTab(pro.cProd);
        rpt.PrintTab(' '+ Tnfeutil.ParseText(pro.xProd,True));
        rpt.PrintTab(pro.NCM);
        rpt.PrintTab(CST                                      	    );
        rpt.PrintTab(IntToStr(pro.CFOP)                       	    );
        rpt.PrintTab(pro.uCom                                 	    );
        rpt.PrintTab(Tnfeutil.FFlt(pro.qCom, '0.000')+' ');
        rpt.PrintTab(Tnfeutil.FCur(pro.vUnCom           ) +' ');
        rpt.PrintTab(Tnfeutil.FCur(pro.vProd						) +' ');
        rpt.PrintTab(Tnfeutil.FCur(vBC									) +' ');
        rpt.PrintTab(Tnfeutil.FCur(vICMS								) +' ');
        rpt.PrintTab(Tnfeutil.FCur(vIPI) +' ');
        rpt.PrintTab(Tnfeutil.FFlt(pICMS								) +' ');
        rpt.PrintTab(Tnfeutil.FFlt(pIPI) +' ');

//        if Tnfeutil.IsNotEmpty(pro.infAdProd) then
//        begin
//            rpt.NewLine;
//            rpt.RestoreTabs(10);
//            rpt.PrintTab(' ');
//            rpt.PrintTab(' '+ pro.infAdProd);
//
            x :=rpt.SectionLeft;
            y :=rpt.YPos ;
            rpt.GotoXY(x, y);

            if c=Itens then
            begin
              	DrawLine(x, y+0.05, rpt.SectionRight, y+0.05);
            end;
//            else begin
//            		DrawLine(x, y+0.05, rpt.SectionRight, y+0.05, psDot);
//            end;
//        end;

    end;

    //
    l :=Itens -c;
    if l > 0 then
    begin
      for i :=1 to l do
      begin
        rpt.NewLine;
        rpt.RestoreTabs(9);
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
        rpt.PrintTab('');
//        rpt.NewLine;
//        rpt.RestoreTabs(10);
//        rpt.PrintTab('');
//        rpt.PrintTab('');
      end;
    end;
    //
    x :=rpt.SectionLeft;
    y :=rpt.YPos;
    rpt.GotoXY(x, y);
    //
    DrawLine(x, y+0.05, rpt.SectionRight, y+0.05);

    // quadro dados adicionais
    DoInfoAdic;

end;

procedure TnfeDanfe.DoStatus(ReportSystem: TRvSystem; OverrideMode: TOverrideMode;
  var OverrideForm: TForm);
begin
    case OverrideMode of
        omShow:
        begin
            TRpStatusForm(OverrideForm).StatusLabel.Caption :='';
        end;
    end;
end;

function TnfeDanfe.Print: Boolean;
var Stream:TStream;
begin
    Result  :=fNFe<>nil;
    if Result then
    begin
        TitlePreview        :=fNFe.Id +'-nfe';
        SystemPrinter.Title :=fNFe.Id +'-nfe';
        if fLogo<>'' then
        begin
            Stream := TFileStream.Create(fLogo, fmOpenRead or fmShareDenyWrite);
            try
              Stream.Position :=0;
              fBitmap.LoadFromStream(Stream);
            finally
              FreeAndNil(Stream);
            end;
        end;
        Self.Execute;
        if not Aborted then
        begin
            fAbortMsg   :='DANFE impresso com sucesso.';
        end;
    end
    else begin
        fAborted  :=True;
        fAbortMsg :='Nota fiscal eletronica não informada!';
    end;
end;

procedure TnfeDanfe.SetCopies(AValue: Integer);
begin
  if AValue > 0 then
  begin
      FCopies :=AValue;
  end;
end;

procedure TnfeDanfe.SetLogo(AValue: string);
var Str: TStream;
begin
  if not Tnfeutil.IsEmpty(AValue) then
  begin
      if FileExists(AValue) then
      begin
          fLogo :=AValue;

          Str := TFileStream.Create(fLogo, fmOpenRead or fmShareDenyWrite);
          try
            Str.Position :=0;
            fBitmap.LoadFromStream(Str);
          finally
            FreeAndNil(Str);
          end;
      end;
//      else begin
//          raise EFilerError.CreateFmt('Arquivo "%s" não encontrado!',[AValue]);
//      end;
  end;
end;

procedure TnfeDanfe.SetOut(AValue: TOutiputDanfe);
begin
  case AValue of
      odPreview: DefaultDest :=rdPreview;
      odPrinter: DefaultDest :=rdPrinter;
      odFile   : begin
                    DefaultDest     :=rdFile;
                    DoNativeOutput  :=False;
                    RenderObject    :=fRvRenderPDF;
                    OutputFileName  :=Format('%s-nfe.pdf', [fNFe.Id]);
                  end;
  end;
end;


{ TdanfeColumn }

constructor TdanfeColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  Self.Justify :=pjLeft;
  Self.Border  :=BOXLINENONE;
  Self.Shade :=0;
  Self.Margin :=0;
  Self.Visible:=False;
end;

{ TdanfeColumns }

function TdanfeColumns.Add: TdanfeColumn;
begin
  Result := TdanfeColumn(inherited Add);
end;

function TdanfeColumns.Get(Index: Integer): TdanfeColumn;
begin
  Result :=TdanfeColumn(inherited Items[Index]);
end;

{ TBaseReportExt }

procedure TBaseReportExt.PrintTab(const Index: Integer; const Text: string;
  const BoxLine: Byte);
var
  tab: TTab;
begin
  tab :=Self.GetTab(Index);
  case BoxLine of
    BOXLINENONE:
    begin
      tab.Left 		:=False;
      tab.Right 	:=False;
      tab.Top 		:=False;
      tab.Bottom	:=False;
    end;
    BOXLINELEFT:
    begin
      tab.Left 		:=True;
      tab.Right 	:=False;
      tab.Top 		:=False;
      tab.Bottom	:=False;
    end;
    BOXLINERIGHT:
    begin
      tab.Left 		:=False;
      tab.Right 	:=True;
      tab.Top 		:=False;
      tab.Bottom	:=False;
    end;
    BOXLINELEFTRIGHT:
    begin
      tab.Left 		:=True;
      tab.Right 	:=True;
      tab.Top 		:=False;
      tab.Bottom	:=False;
    end;
    BOXLINETOP:
    begin
      tab.Left 		:=False;
      tab.Right 	:=False;
      tab.Top 		:=True;
      tab.Bottom	:=False;
    end;
    BOXLINELEFTTOP:
    begin
      tab.Left 		:=True;
      tab.Right 	:=False;
      tab.Top 		:=True;
      tab.Bottom	:=False;
    end;
    BOXLINERIGHTTOP:
    begin
      tab.Left 		:=False;
      tab.Right 	:=True;
      tab.Top 		:=True;
      tab.Bottom	:=False;
    end;
    BOXLINENOBOTTOM:
    begin
      tab.Left 		:=True;
      tab.Right 	:=True;
      tab.Top 		:=True;
      tab.Bottom	:=False;
    end;
    BOXLINEBOTTOM:
    begin
      tab.Left 		:=False;
      tab.Right 	:=False;
      tab.Top 		:=False;
      tab.Bottom	:=True;
    end;
    BOXLINELEFTBOTTOM:
    begin
      tab.Left 		:=True;
      tab.Right 	:=False;
      tab.Top 		:=False;
      tab.Bottom	:=True;
    end;
    BOXLINERIGHTBOTTOM:
    begin
      tab.Left 		:=False;
      tab.Right 	:=True;
      tab.Top 		:=False;
      tab.Bottom	:=True;
    end;
    BOXLINENOTOP:
    begin
      tab.Left 		:=True;
      tab.Right 	:=True;
      tab.Top 		:=False;
      tab.Bottom	:=True;
    end;
    BOXLINETOPBOTTOM:
    begin
      tab.Left 		:=False;
      tab.Right 	:=False;
      tab.Top 		:=True;
      tab.Bottom	:=True;
    end;
    BOXLINENORIGHT:
    begin
      tab.Left 		:=True;
      tab.Right 	:=False;
      tab.Top 		:=True;
      tab.Bottom	:=True;
    end;
    BOXLINENOLEFT:
    begin
      tab.Left 		:=False;
      tab.Right 	:=True;
      tab.Top 		:=True;
      tab.Bottom	:=True;
    end;
    BOXLINEALL:
    begin
      tab.Left 		:=True;
      tab.Right 	:=True;
      tab.Top 		:=True;
      tab.Bottom	:=True;
    end;
  else
    tab.Left 		:=False;
    tab.Right 	:=False;
    tab.Top 		:=False;
    tab.Bottom	:=False;
  end;
  Self.PrintTab(Text);
end;

{ TCustomDANFe }

constructor TCustomDANFe.Create(AOrientation: TRvOrientation);
begin
  inherited Create(AOrientation);

  MarginTop :=0.50;
  MarginBottom :=0.50;
  MarginLeft :=0.50;
  MarginRight :=0.50;

  FBlcCanhoto :=TdanfeBlcCanhoto.Create(Self);
  FBlcCab :=TdanfeBlcCab.Create(Self) ;
  FBlcDestRem :=TdanfeBlcDestRem.Create(Self);
  FBlcFatDups :=TdanfeBlcCobr.Create(Self);
  FBlcCalcImposto :=TdanfeBlcCalcImposto.Create(Self) ;
  FBlcTransp :=TdanfeBlcTransp.Create(Self);
  FBlcProd :=TdanfeBlcProd.Create(Self) ;
  FBlcAdic :=TdanfeBlcAdic.Create(Self) ;

end;

destructor TCustomDANFe.Destroy;
begin
  FBlcCanhoto.Destroy;
  FBlcCab.Destroy;
  FBlcDestRem.Destroy;
  FBlcFatDups.Destroy;
  FBlcCalcImposto.Destroy;
  FBlcTransp.Destroy;
  FBlcProd.Destroy;
  inherited;
end;

procedure TCustomDANFe.DoInit(Sender: TObject);
var
  I: Integer;
  C: TdanfeColumn ;
begin
  inherited DoInit(Sender);

  if BlcFatDups.PrintBloco then
  begin
    Report.ClearTabs;
    for I :=0 to BlcFatDups.Colunas.Count -4 do
    begin
      C :=BlcFatDups.Colunas.Items[I] ;
      Report.SetTab(C.PosX, C.Justify, C.Width, C.Margin, C.Border, C.Shade);
    end;
    Report.SaveTabs(TAB_DUP_COL1);

    Report.ClearTabs;
    for I :=3 to BlcFatDups.Colunas.Count -1 do
    begin
      C :=BlcFatDups.Colunas.Items[I] ;
      Report.SetTab(C.PosX, C.Justify, C.Width, C.Margin, C.Border, C.Shade);
    end;
    Report.SaveTabs(TAB_DUP_COL2);
  end;

  Report.ClearTabs;
  for I :=0 to BlcProd.Colunas.Count -1 do
  begin
    C :=BlcProd.Colunas.Items[I] ;
    if C.Visible then
    begin
      Report.SetTab(C.PosX, C.Justify, C.Width, C.Margin, C.Border, C.Shade);
    end;
  end;
  Report.SaveTabs(TAB_PROD);

  Report.ClearTabs;
  for I :=0 to BlcProd.Colunas.Count -1 do
  begin
    C :=BlcProd.Colunas.Items[I] ;
    if C.Visible then
    begin
      Report.SetTab(C.PosX, C.Justify, C.Width, C.Margin, C.Border, C.Shade);
    end;
  end;
  Report.SaveTabs(TAB_PROD_AD);

end;

procedure TCustomDANFe.RenderToPDF(const ALocal: string);
var
  local,pdf: string ;
begin
  local :=Trim(ALocal) ;
  if DirectoryExists(local) then
  begin
    local :=ExcludeTrailingPathDelimiter(local);
    pdf   :=Format('%s\%s-nfe.pdf',[local, NFe.Id]);
  end
  else begin
    pdf   :=Format('%s-nfe.pdf',[NFe.Id]);
  end;
  Self.OutputFileName :=pdf;
  Self.DoExecute(rdFile, roPDF);
end;


procedure TCustomDANFe.RenderToPrinter(const APrinterName: string;
  const ACopies: Integer);
begin
  Self.PrinterName :=APrinterName ;
  Self.Copies :=ACopies ;
  Self.DoExecute(rdPrinter);
end;

{ TdanfeBloco }

procedure TdanfeBloco.PQuadro(const AposX, AposY: Double;
  const AQuadro: TdanfeQuadro;
  const ABold: Boolean);
var
  FStyle: TFontStyles;
  localY: Double;
begin
  Owner.DrawBox(AposX, AposY, AQuadro.Largura, AQuadro.Altura, 0.10);
  Owner.SetFont(FONT_SIZE_6);

  if AQuadro.Rotacao > 0 then
  begin
    Owner.Report.FontRotation :=AQuadro.Rotacao;
  end;

  Owner.PrintBox(0, 0, AQuadro.Titulo);

  if AQuadro.Texto <> '' then
  begin

    FStyle :=[];
    if AQuadro.Bold then
    begin
      FStyle :=[fsBold];
    end;

    if Self is TdanfeBlcAdic then
    begin
      Owner.SetFont(FONT_SIZE_8);
    end
    else begin
      Owner.SetFont(FONT_SIZE_10);
    end;

    Owner.Box.SetBox(AQuadro.Just);

    if AQuadro.Rotacao > 0 then
    begin
      Owner.Report.FontRotation :=AQuadro.Rotacao;
    end;

    if Owner.Report.TextWidth(AQuadro.Texto) > AQuadro.Largura then
    begin
      localY :=Owner.Report.LineHeight/2;
      Owner.PrintBox(0, localY, AQuadro.Texto, FStyle, 8);
    end
    else begin
      localY :=AQuadro.Altura -Owner.Report.LineHeight;
      Owner.PrintBox(0, localY, AQuadro.Texto, FStyle);
    end;

  end;

  if Owner.Report.FontRotation > 0 then
  begin
    Owner.Report.FontRotation :=0;
  end;

end;

{ TdanfeQuadro }

constructor TdanfeQuadro.Create;
begin
  Just :=pjLeft;
  Bold :=False;
  Rotacao:=0;
end;

procedure TdanfeQuadro.DoConfig(const Altura, Largura: Double;
  const Titulo, Texto: string;
  const Just: TPrintJustify;
  const Bold: Boolean ;
  const Rotacao: Integer);
begin
  Self.Altura :=Altura;
  Self.Largura:=Largura;
  Self.Titulo :=Titulo;
  Self.Texto  :=Texto;
  Self.Just :=Just ;
  Self.Bold :=False;
  Self.Rotacao :=Rotacao;
end;

{ TdanfeBlcCanhoto }

constructor TdanfeBlcCanhoto.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;

  QReceb :=TdanfeQuadro.Create ;
  QDataReceb :=TdanfeQuadro.Create;
  QAssina :=TdanfeQuadro.Create;
  QIdNFE :=TdanfeQuadro.Create;
end;

destructor TdanfeBlcCanhoto.Destroy;
begin
  QReceb.Destroy ;
  QDataReceb.Destroy ;
  QAssina.Destroy ;
  QIdNFE.Destroy ;
  inherited;
end;

procedure TdanfeBlcCanhoto.DoPrint();
begin
  //
  X :=Owner.Report.MarginLeft;
  Y :=Owner.Report.MarginTop ;
  //

  //Quadro recebimento...
  PQuadro(X, Y, QReceb);

  //NF-e/Nº 000.000.000/SÉRIE 000
  //PQuadro(NA, Y, QIdNFE, True);

  //Quadro Data de recebimento
  PQuadro(X, Y +QReceb.Altura, QDataReceb);

  //Quadro Id e Assinatura...
  PQuadro(NA, Owner.Box.Top, QAssina);

  //NF-e/Nº 000.000.000/SÉRIE 000
  Owner.SetFont(FONT_SIZE_10);
  Owner.DrawBox(NA, Y, QIdNFE.Largura, QIdNFE.Altura, 0.10, 0, pjCenter, [fsBold]);
  Owner.PrintBox(QIdNFE.Texto, 0, 0, 5);

  Y :=Owner.Box.Bottom +DIST_IN_BLOCO /2;
  Owner.DrawLineHorz(Y, psDashDotDot);
  Y :=Y +DIST_IN_BLOCO /2;

end;

procedure TdanfeBlcCanhoto.DoPrintLandScape;
var
  H: Double;
begin
  X :=Owner.Report.MarginLeft;
  Y :=Owner.Report.MarginTop ;
  with Owner do
  begin

    //NF-e/Nº 000.000.000/SÉRIE 000
    PQuadro(X, Y, QIdNFE, True);
    {SetFont(FONT_SIZE_10); H :=Report.FontHeight; Report.Bold :=True; Report.FontRotation :=90;
    DrawBox(X     , Y, QIdNFE.Largura, QIdNFE.Altura); X :=Box.Left; Y :=Box.Top +Box.Height/2;
    PrintXY(X   +H, Y, 'NF-e', pjCenter); X :=X +Report.LineHeight;
    PrintXY(X +2*H, Y, 'Nº: '+ Tnfeutil.FNumDocFiscal(NFe.ide.nNF), pjCenter);
    PrintXY(X +3*H, Y, 'SÉRIE: '+ Tnfeutil.FInt(NFe.ide.serie,3     ), pjCenter);

    //Quadro recebimento...
    DrawBox(NA, Box.Right, QIdNFE.Largura, QIdNFE.Altura); X :=Box.Left; Y :=Box.Top +Box.Height/2;
    }

    //Quadro Id e Assinatura...

    //Quadro Data de recebimento

    X :=Box.Right +DIST_IN_BLOCO /2;
    DrawLineVert(X, psDashDotDot);
    Y :=Y +DIST_IN_BLOCO /2;

    Report.FontRotation :=00;
    Report.Bold :=False;

  end;
end;

{ TdanfeBlcCab }

constructor TdanfeBlcCab.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;

  QIdEmit :=TdanfeQuadro.Create;
  QDanfe :=TdanfeQuadro.Create ;
  QCodBar :=TdanfeQuadro.Create;
  QChave :=TdanfeQuadro.Create ;
  QCampo1 :=TdanfeQuadro.Create;
  QNatOpe :=TdanfeQuadro.Create;
  QCampo2 :=TdanfeQuadro.Create;
  QIE :=TdanfeQuadro.Create;
  QIEST :=TdanfeQuadro.Create;
  QCNPJ :=TdanfeQuadro.Create;
end;

destructor TdanfeBlcCab.Destroy;
begin
  QIdEmit.Destroy;
  QDanfe.Destroy ;
  QCodBar.Destroy;
  QChave.Destroy;
  QCampo1.Destroy;
  QNatOpe.Destroy;
  QCampo2.Destroy;
  QIE.Destroy;
  QIEST.Destroy;
  QCNPJ.Destroy;
  if Assigned(FBitmap) then
  begin
    FBitmap.Free ;
  end;
  inherited;
end;

procedure TdanfeBlcCab.DoPrint;
var
  xNome: string;
  xLogr: string;
  xBairro: string;
  xLocal: string;
  xFone: string;

var
  P,H: Double;

begin
  with Owner do
  begin
    xNome  :=Tnfeutil.ParseText(NFe.emit.xNome            , True);
    xLogr  :=Tnfeutil.ParseText(NFe.emit.ender.xLgr   , True);
    xBairro:=Tnfeutil.ParseText(NFe.emit.ender.xBairro, True);
    xLocal :=Tnfeutil.ParseText(NFe.emit.ender.xMun   , True);
    xLocal :=Format('%s-%s  %s',[xLocal, NFe.emit.ender.UF,
                                Tnfeutil.FormatCEP(NFe.emit.ender.CEP)]);
    xFone :=Tnfeutil.FormatFone(NFe.emit.ender.fone);

    //Quadro identificação do emitente
    DrawBox(X, Y, QIdEmit.Largura, QIdEmit.Altura, 0.10, 10, pjLeft, [fsBold]); SetFont(FONT_SIZE_6); Y :=Report.LineHeight;
    PrintBox(0, 0, QIdEmit.Titulo); SetFont(FONT_SIZE_12);
    PrintBox(0, 2*Y +Y/2, xNome, [fsBold], 8); SetFont(FONT_SIZE_10); X :=2.00;
    PrintBox(X, NA, xLogr  , [fsBold]); H :=Report.LineTop;
    PrintBox(X, NA, xBairro, [fsBold]);
    PrintBox(X, NA, xLocal , [fsBold]);
    PrintBox(X, NA, xFone  , [fsBold]);

    if Assigned(FBitmap) then
    begin
      X :=Box.Left +Box.Margin; Y :=H; H :=Report.FontHeight;
      Report.PrintBitmapRect(X, Y, X +1.80, 3*H, FBitmap);
      //Report.StretchDraw(Report.CreateRect(X, Y, X +1.80, 3*H), FBitmap);
    end;

{
    DrawBox(X, Y, Report.SectionRight, HCX_CAB, 0.10, 0, pjLeft, [fsBold]); X :=2;
    PrintBox(txt, X, 0);

    if Assigned(BlcCab.FBitmap) then
    begin
      X :=Box.Left +Box.Margin; Y :=Box.Top +0.10; // Report.LineTop ;
      Report.PrintBitmapRect(X, Y, X +1.80, Y +3*Report.LineHeight -0.10, BlcCab.FBitmap);
    end;

    X :=Report.MarginLeft;

}
    //Quadro da descrição "DANFE"
    DrawBox(NA, Box.Top, QDanfe.Largura, QDanfe.Altura, 0, 0, pjCenter); SetFont(FONT_SIZE_12);
    PrintBox(0, 0, QDanfe.Titulo, [fsBold]); SetFont(FONT_SIZE_8); Y :=Report.LineHeight;
    PrintBox(0, 2*Y +Y/3, QDanfe.Texto, [fsBold], 8); Box.SetBox(pjLeft);
    PrintBox(0, 6*Y +Y/3, '0-ENTRADA'); Y :=Report.LineHeight; P :=Report.LineTop;
    PrintBox(0, 7*Y +Y/3, '1-SAIDA' ); SetFont(FONT_SIZE_10); Y :=Report.FontHeight;
    PrintBox(0, 8*Y +Y/3, 'Nº:'); X :=0.46;
    PrintBox(X, 8*Y +Y/3, Tnfeutil.FormatDocFiscal(NFe.ide.nNF), [fsBold]);
    PrintBox(X, 9*Y +Y/3, 'SÉRIE:'); X :=1.55;
    PrintBox(X, 9*Y +Y/3, Tnfeutil.FInt(NFe.ide.serie,3), [fsBold]); X :=0.46;
    PrintBox(X, 10*Y +Y/3, 'FOLHA:'); X :=1.70; H :=Report.LineHeight;
    PrintBox(X, 10*Y +Y/3, FormatNumPage('%d/%d'), [fsBold]); X :=Box.Right; Y :=Box.Top;
    DrawBox(Box.Left +1.70, P, 0.50, H, 0, 0, pjCenter);
    PrintBox(0, 0, IntToStr(Ord(NFe.ide.tpNF)), [fsBold]);

    //Quadro código de barras da chave
    DrawBox(X, Y, QCodBar.Largura, QCodBar.Altura); X :=(Box.Width -6)/2 ; Y :=0.12;
    PrintBarCod128(NFe.Id, Box.Left +X, Box.Top +Y, QCodBar.Altura -0.25, 0.02);

    //Quadro chave de acesso
    //PrintQuadro(Box.Left, NA, QChave.Largura, QChave.Altura, QChave.Titulo, QChave.Texto, pjLeft, True);
    PQuadro(Box.Left, NA, QChave);

    //Quadro codigo de barras dos dados
    DrawBox(Box.Left, NA, QCampo1.Largura, QCampo1.Altura, 0.10);
    if NFe.ide.tpEmis in[emisNomal,emisCon_SCAN] then
    begin
      PrintBox(0, 0, QCampo1.Texto);
    end
    else begin
      X :=(Box.Width -6)/2 ; Y :=0.12;
      Text :=StringReplace(QCampo1.Texto, ' ', '', [rfReplaceAll]);
      PrintBarCod128(Text, Box.Left +X, Box.Top +Y, QCampo1.Altura -0.25, 0.02);
    end;

    //Quadro natureza da operação
    X :=Report.MarginLeft;
    //PrintQuadro(X, NA, QNatOpe.Largura, QNatOpe.Altura, QNatOpe.Titulo, QNatOpe.Texto);
    PQuadro(X, NA, QNatOpe);

    //Quadro dados da NF-e
    //PrintQuadro(NA, Box.Top, QCampo2.Largura, QCampo2.Altura, QCampo2.Titulo, QCampo2.Texto);
    PQuadro(NA, Box.Top, QCampo2);

    //Quadro inscrição estadual do emitente
    X :=Report.MarginLeft;
    //PrintQuadro(X, NA, QIE.Largura, QIE.Altura, QIE.Titulo, QIE.Texto);
    PQuadro(X, NA, QIE);

    //Quadro inscrição estadual de ST do emitente
    //PrintQuadro(NA, Box.Top, QIEST.Largura, QIEST.Altura, QIEST.Titulo, QIEST.Texto);
    PQuadro(NA, Box.Top, QIEST);

    //Quadro cnpj do emitente
    //PrintQuadro(NA, Box.Top, QCNPJ.Largura, QCNPJ.Altura, QCNPJ.Titulo, QCNPJ.Texto);
    PQuadro(NA, Box.Top, QCNPJ);
  end;

end;

procedure TdanfeBlcCab.SetLogo(const Value: string);
begin
  if (Value<>'') and FileExists(Value) then
  begin
    FLogo :=Value ;
    FBitmap :=TBitmap.Create;
    FBitmap.LoadFromFile(FLogo);
  end;
end;

{ TdanfeBlcDestRem }

constructor TdanfeBlcDestRem.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;

  QNome :=TdanfeQuadro.Create;
  QCNPJ :=TdanfeQuadro.Create;
  QDtEmis :=TdanfeQuadro.Create;
  QEnd :=TdanfeQuadro.Create;
  QBairro :=TdanfeQuadro.Create;
  QCEP :=TdanfeQuadro.Create;
  QDtEntSai :=TdanfeQuadro.Create;
  QMun :=TdanfeQuadro.Create;
  QFone :=TdanfeQuadro.Create;
  QUF :=TdanfeQuadro.Create;
  QIE :=TdanfeQuadro.Create;
  QHrEntSai :=TdanfeQuadro.Create;
end;

destructor TdanfeBlcDestRem.Destroy;
begin
  QNome.Destroy ;
  QCNPJ.Destroy ;
  QDtEmis.Destroy ;
  QEnd.Destroy ;
  QBairro.Destroy ;
  QCEP.Destroy ;
  QDtEntSai.Destroy ;
  QMun.Destroy ;
  QFone.Destroy ;
  QUF.Destroy ;
  QIE.Destroy ;
  QHrEntSai.Destroy ;
  inherited;
end;

procedure TdanfeBlcDestRem.DoPrint;
begin
  with Owner do
  begin
    SetFont(FONT_SIZE_6); X :=Report.MarginLeft; Y :=Box.Bottom +DIST_IN_BLOCO;
    PrintXY(X, Y, 'DESTINATÁRIO/REMETENTE', pjLeft, [fsBold]);

    //Quadro Razão Social/Nome
    //PrintQuadro(X, Y, QNome.Largura, QNome.Altura, QNome.Titulo, QNome.Texto);
    PQuadro(X, Y, QNome);

    //Quadro Cnpj/Cpf
    //PrintQuadro(NA, Y, QCnpj.Largura, QCnpj.Altura, QCnpj.Titulo, QCnpj.Texto, pjLeft, True);
    PQuadro(NA, Y, QCnpj);

    //Quadro data da emissão
    //PrintQuadro(NA, Y, QDtEmis.Largura, QDtEmis.Altura, QDtEmis.Titulo, QDtEmis.Texto);
    PQuadro(NA, Y, QDtEmis);

    //Quadro endereço
    X :=Report.MarginLeft;
    //PrintQuadro(X, NA, QEnd.Largura, QEnd.Altura, QEnd.Titulo, QEnd.Texto);
    PQuadro(X, NA, QEnd);

    //Quadro Bairro/Distrito
    Y :=Box.Top;
    //PrintQuadro(NA, Y, QBairro.Largura, QBairro.Altura, QBairro.Titulo, QBairro.Texto);
    PQuadro(NA, Y, QBairro);

    //Quadro CEP
    //PrintQuadro(NA, Y, QCEP.Largura, QCEP.Altura, QCEP.Titulo, QCEP.Texto);
    PQuadro(NA, Y, QCEP);

    //Quadro data da entrada/saida
    //PrintQuadro(NA, Y, QDtEntSai.Largura, QDtEntSai.Altura, QDtEntSai.Titulo, QDtEntSai.Texto, pjLeft, True);
    PQuadro(NA, Y, QDtEntSai);

    //Quadro município
    X :=Report.MarginLeft;
    //PrintQuadro(X, NA, QMun.Largura, QMun.Altura, QMun.Titulo, QMun.Texto);
    PQuadro(X, NA, QMun);

    //Quadro fone/fax
    Y :=Box.Top ;
    //PrintQuadro(NA, Y, QFone.Largura, QFone.Altura, QFone.Titulo, QFone.Texto);
    PQuadro(NA, Y, QFone);

    //Quadro UF
    //PrintQuadro(NA, Y, QUF.Largura, QUF.Altura, QUF.Titulo, QUF.Texto);
    PQuadro(NA, Y, QUF);

    //Quadro inscrição estadual
    //PrintQuadro(NA, Y, QIE.Largura, QIE.Altura, QIE.Titulo, QIE.Texto);
    PQuadro(NA, Y, QIE);

    //Quadro hora da entrada/saida
    //PrintQuadro(NA, Y, QHrEntSai.Largura, QHrEntSai.Altura, QHrEntSai.Titulo, QHrEntSai.Texto, pjLeft, True);
    PQuadro(NA, Y, QHrEntSai);
  end;

end;

{ TdanfeBlcCobr }

constructor TdanfeBlcCobr.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;
  FColumns :=TdanfeColumns.Create(TdanfeColumn) ;
end;

destructor TdanfeBlcCobr.Destory;
begin
  FColumns.Destroy ;
  inherited;
end;

procedure TdanfeBlcCobr.DoPrint;
var
  I,C: Integer;
  P: Double ;
var
  dup: TdupList.Tdup;
  FDupNum,FDupVenc,FDupVal: string;
begin
  with Owner do
  begin
    X :=Report.MarginLeft;
    Y :=Box.Bottom +DIST_IN_BLOCO;

    SetFont(FONT_SIZE_6);
    PrintXY(X, Y, 'FATURA/DUPLICATAS', pjLeft, [fsBold]);
    SetFont(FONT_SIZE_8);

    Report.LineHeightMethod :=lhmLinesPerInch;
    Report.LinesPerInch :=8;

    P :=Y;

    C :=NFe.cobr.dup.Count;
    if C <= 3 then C :=3;
    if C > 3  then C :=6;

    for I :=0 to C -1 do
    begin
      if I < NFe.cobr.dup.Count then
      begin
        dup :=NFe.cobr.dup.Items[I];
        FDupNum :='Número: '+ dup.nDup;
        FDupVenc:='Dt.Venc: '+ Tnfeutil.FDat(dup.dVenc);
        FDupVal :='Valor: '+Tnfeutil.FCur(dup.vDup);
      end
      else begin
        FDupNum :='';
        FDupVenc:='';
        FDupVal :='';
      end;

      if Odd(i) then
      begin
        Report.TabShade :=15;
      end
      else begin
        Report.TabShade :=0;
      end;

      if I < 3 then
      begin
        Report.NewLine;
        Report.RestoreTabs(TAB_DUP_COL1);
        if I = 0 then
        begin
          Report.PrintTab(1, FDupNum , BOXLINELEFTTOP);
          Report.PrintTab(2, FDupVenc, BOXLINETOP);
          Report.PrintTab(3, FDupVal , BOXLINERIGHTTOP);
        end
        else begin
          if I = 2 then
          begin
            Report.PrintTab(1, FDupNum , BOXLINELEFTBOTTOM);
            Report.PrintTab(2, FDupVenc, BOXLINEBOTTOM);
            Report.PrintTab(3, FDupVal , BOXLINERIGHTBOTTOM);
          end
          else begin
            Report.PrintTab(1, FDupNum , BOXLINELEFT);
            Report.PrintTab(2, FDupVenc, BOXLINENONE);
            Report.PrintTab(3, FDupVal , BOXLINERIGHT);
          end;
        end;
      end
      else begin
        if I = 3 then
        begin
          Report.GotoXY(X, P);
        end;
        Report.NewLine;
        Report.RestoreTabs(TAB_DUP_COL2);
        if I = 3 then
        begin
          Report.PrintTab(1, FDupNum , BOXLINELEFTTOP);
          Report.PrintTab(2, FDupVenc, BOXLINETOP);
          Report.PrintTab(3, FDupVal , BOXLINERIGHTTOP);
        end
        else begin
          if I = 5 then
          begin
            Report.PrintTab(1, FDupNum , BOXLINELEFTBOTTOM);
            Report.PrintTab(2, FDupVenc, BOXLINEBOTTOM);
            Report.PrintTab(3, FDupVal , BOXLINERIGHTBOTTOM);
          end
          else begin
            Report.PrintTab(1, FDupNum , BOXLINELEFT);
            Report.PrintTab(2, FDupVenc, BOXLINENONE);
            Report.PrintTab(3, FDupVal , BOXLINERIGHT);
          end;
        end;
      end;
    end;
    Report.LineHeightMethod :=lhmFont;
    Report.LinesPerInch :=6;
  end;
end;

{ TdanfeBlcCalcImposto }

constructor TdanfeBlcCalcImposto.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;

  QvBC :=TdanfeQuadro.Create;
  QvICMS :=TdanfeQuadro.Create;
  QvBCST :=TdanfeQuadro.Create;
  QvST :=TdanfeQuadro.Create;
  QvProd :=TdanfeQuadro.Create;
  QvFrete:=TdanfeQuadro.Create;
  QvSeg :=TdanfeQuadro.Create;
  QvDesc :=TdanfeQuadro.Create;
  QvOutro:=TdanfeQuadro.Create;
  QvIPI :=TdanfeQuadro.Create;
  QvNF :=TdanfeQuadro.Create;
end;

destructor TdanfeBlcCalcImposto.Destory;
begin
  QvBC.Destroy ;
  QvICMS.Destroy ;
  QvBCST.Destroy ;
  QvST.Destroy ;
  QvProd.Destroy ;
  QvFrete.Destroy ;
  QvSeg.Destroy ;
  QvDesc.Destroy ;
  QvOutro.Destroy ;
  QvIPI.Destroy ;
  QvNF.Destroy ;
end;

procedure TdanfeBlcCalcImposto.DoPrint;
begin
  with Owner do
  begin
    SetFont(FONT_SIZE_6); X :=Report.MarginLeft; Y :=Box.Bottom +DIST_IN_BLOCO;
    PrintXY(X, Y, 'CÁLCULO DO IMPOSTO', pjLeft, [fsBold]); SetFont(FONT_SIZE_8);

//    PrintQuadro(X , Y, QvBC.Largura  , QvBC.Altura  , QvBC.Titulo  , QvBC.Texto  , pjRight);
//    PrintQuadro(NA, Y, QvICMS.Largura, QvICMS.Altura, QvICMS.Titulo, QvICMS.Texto, pjRight);
//    PrintQuadro(NA, Y, QvBCST.Largura, QvBCST.Altura, QvBCST.Titulo, QvBCST.Texto, pjRight);
//    PrintQuadro(NA, Y, QvST.Largura  , QvST.Altura  , QvST.Titulo  , QvST.Texto  , pjRight);
//    PrintQuadro(NA, Y, QvProd.Largura, QvProd.Altura, QvProd.Titulo, QvProd.Texto, pjRight);
    PQuadro(X , Y, QvBC);
    PQuadro(NA, Y, QvICMS);
    PQuadro(NA, Y, QvBCST);
    PQuadro(NA, Y, QvST);
    PQuadro(NA, Y, QvProd);

    X :=Report.MarginLeft; Y :=Box.Bottom ;
//    PrintQuadro(X , Y, QvFrete.Largura, QvFrete.Altura, QvFrete.Titulo, QvFrete.Texto, pjRight);
//    PrintQuadro(NA, Y, QvSeg.Largura, QvSeg.Altura, QvSeg.Titulo, QvSeg.Texto, pjRight);
//    PrintQuadro(NA, Y, QvDesc.Largura, QvDesc.Altura, QvDesc.Titulo, QvDesc.Texto, pjRight);
//    PrintQuadro(NA, Y, QvOutro.Largura, QvOutro.Altura, QvOutro.Titulo, QvOutro.Texto, pjRight);
//    PrintQuadro(NA, Y, QvIPI.Largura, QvIPI.Altura, QvIPI.Titulo, QvIPI.Texto, pjRight);
//    PrintQuadro(NA, Y, QvNF.Largura, QvNF.Altura, QvNF.Titulo, QvNF.Texto, pjRight, True);
    PQuadro(X , Y, QvFrete);
    PQuadro(NA, Y, QvSeg);
    PQuadro(NA, Y, QvDesc);
    PQuadro(NA, Y, QvOutro);
    PQuadro(NA, Y, QvIPI);
    PQuadro(NA, Y, QvNF);
  end;
end;

{ TdanfeBlcTransp }

constructor TdanfeBlcTransp.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;

  QNome   :=TdanfeQuadro.Create ;
  QFrete  :=TdanfeQuadro.Create ;
  QCodANTT:=TdanfeQuadro.Create;
  QPlcNum :=TdanfeQuadro.Create ;
  QPlcUF  :=TdanfeQuadro.Create ;
  QCNPJ   :=TdanfeQuadro.Create ;
  QEnd  :=TdanfeQuadro.Create ;
  QMun  :=TdanfeQuadro.Create ;
  QUF :=TdanfeQuadro.Create ;
  QIE :=TdanfeQuadro.Create ;
  QQtdVol :=TdanfeQuadro.Create ;
  QEsp  :=TdanfeQuadro.Create ;
  QMarca:=TdanfeQuadro.Create ;
  QNum  :=TdanfeQuadro.Create ;
  QPesoBrt:=TdanfeQuadro.Create ;
  QPesoLiq:=TdanfeQuadro.Create ;
end;

destructor TdanfeBlcTransp.Destory;
begin
  QNome.Destroy ;
  QFrete.Destroy ;
  QCodANTT.Destroy ;
  QPlcNum.Destroy ;
  QPlcUF.Destroy ;
  QCNPJ.Destroy ;
  QEnd.Destroy ;
  QMun.Destroy ;
  QUF.Destroy ;
  QIE.Destroy ;
  QQtdVol.Destroy ;
  QEsp.Destroy ;
  QMarca.Destroy ;
  QNum.Destroy ;
  QPesoBrt.Destroy ;
  QPesoLiq.Destroy ;
  inherited;
end;

procedure TdanfeBlcTransp.DoPrint;
begin
  with Owner do
  begin
    SetFont(FONT_SIZE_6); X :=Report.MarginLeft; Y :=Box.Bottom +DIST_IN_BLOCO;
    PrintXY(X, Y, 'TRANSPORTADOR/VOLUMES TRANSPORTADOS', pjLeft, [fsBold]); SetFont(FONT_SIZE_8);

//    PrintQuadro(X , Y, QNome.Largura, QNome.Altura, QNome.Titulo, QNome.Texto);
//    PrintQuadro(NA, Y, QFrete.Largura, QFrete.Altura, QFrete.Titulo, QFrete.Texto);
//    PrintQuadro(NA, Y, QCodANTT.Largura, QCodANTT.Altura, QCodANTT.Titulo, QCodANTT.Texto);
//    PrintQuadro(NA, Y, QPlcNum.Largura, QPlcNum.Altura, QPlcNum.Titulo, QPlcNum.Texto);
//    PrintQuadro(NA, Y, QPlcUF.Largura, QPlcUF.Altura, QPlcUF.Titulo, QPlcUF.Texto);
//    PrintQuadro(NA, Y, QCNPJ.Largura, QCNPJ.Altura, QCNPJ.Titulo, QCNPJ.Texto);
    PQuadro(X , Y, QNome);
    PQuadro(NA, Y, QFrete);
    PQuadro(NA, Y, QCodANTT);
    PQuadro(NA, Y, QPlcNum);
    PQuadro(NA, Y, QPlcUF);
    PQuadro(NA, Y, QCNPJ);

    X   :=Report.MarginLeft; Y :=Box.Bottom;
//    PrintQuadro(X , Y, QEnd.Largura, QEnd.Altura, QEnd.Titulo, QEnd.Texto);
//    PrintQuadro(NA, Y, QMun.Largura, QCNPJ.Altura, QCNPJ.Titulo, QCNPJ.Texto);
//    PrintQuadro(NA, Y, QUF.Largura, QUF.Altura, QUF.Titulo, QUF.Texto);
//    PrintQuadro(NA, Y, QIE.Largura, QIE.Altura, QIE.Titulo, QIE.Texto);
    PQuadro(X , Y, QEnd);
    PQuadro(NA, Y, QMun);
    PQuadro(NA, Y, QUF);
    PQuadro(NA, Y, QIE);

    X :=Report.MarginLeft; Y :=Box.Bottom;
//    PrintQuadro(X , Y, QQtdVol.Largura, QQtdVol.Altura, QQtdVol.Titulo, QQtdVol.Texto, pjRight);
//    PrintQuadro(NA, Y, QEsp.Largura, QEsp.Altura, QEsp.Titulo, QEsp.Texto);
//    PrintQuadro(NA, Y, QMarca.Largura, QMarca.Altura, QMarca.Titulo, QMarca.Texto);
//    PrintQuadro(NA, Y, QNum.Largura, QNum.Altura, QNum.Titulo, QNum.Texto);
//    PrintQuadro(NA, Y, QPesoBrt.Largura, QPesoBrt.Altura, QPesoBrt.Titulo, QPesoBrt.Texto, pjRight);
//    PrintQuadro(NA, Y, QPesoLiq.Largura, QPesoLiq.Altura, QPesoLiq.Titulo, QPesoLiq.Texto, pjRight);
    PQuadro(X , Y, QQtdVol);
    PQuadro(NA, Y, QEsp);
    PQuadro(NA, Y, QMarca);
    PQuadro(NA, Y, QNum);
    PQuadro(NA, Y, QPesoBrt);
    PQuadro(NA, Y, QPesoLiq);
  end;
end;

{ TdanfeBlcProd }

constructor TdanfeBlcProd.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;
  FInfAdProd :=False ;
  FColumns :=TdanfeColumns.Create(TdanfeColumn);
  CreateColumns();
//  VisibleColumns :=[pcCProd, pcXProd,  pcNCM, pcCST, pcCFOP, pcUnid, pcQtde,
//    pcVUnit, pcVTot, pcVBC, pcVICMS, pcVIPI, pcAliqICMS, pcAliqIPI] ;
end;

procedure TdanfeBlcProd.CreateColumns;
var
  C: TdanfeColumn;
begin
  { Código do Produto/Serviço }
  C :=FColumns.Add;
  C.Caption:='CODIGO PRODUTO';
  C.PosX   :=Owner.MarginLeft;
  C.Width  :=1.27;
  C.Justify:=pjCenter;
  C.Border :=BOXLINELEFTRIGHT;

  { Descrição do Produto/Serviço }
  C :=FColumns.Add;
  C.Caption :='DESCRIÇÃO DO PRODUTO/SERVIÇO';
  C.PosX   :=NA;
  C.Width  :=5.83;
  C.Justify:=pjLeft;
  C.Border :=BOXLINELEFTRIGHT;

  { *** Colunas específicas da empresa, informe aqui *** }
  C :=FColumns.Add;
  C.Caption:='VALOR DO FRETE';
  C.PosX   :=NA;
  C.Width  :=1.25;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  C :=FColumns.Add;
  C.Caption :='VALOR DO SEGURO';
  C.PosX   :=NA;
  C.Width  :=1.25;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  C :=FColumns.Add;
  C.Caption :='VALOR DE OUTROS';
  C.PosX   :=NA;
  C.Width  :=1.25;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;
  { *** fim *** }


  { NCM/SH }
  C :=FColumns.Add;
  C.Caption :='NCM/SH';
  C.PosX   :=NA;
  C.Width  :=1.25;
  C.Justify:=pjCenter;
  C.Border :=BOXLINELEFTRIGHT;

  { CST }
  C :=FColumns.Add;
  C.Caption :='CST';
  C.PosX   :=NA;
  C.Width  :=0.56;
  C.Justify:=pjCenter;
  C.Border :=BOXLINELEFTRIGHT;

  { CFOP }
  C :=FColumns.Add;
  C.Caption :='CFOP';
  C.PosX   :=NA;
  C.Width  :=0.76;
  C.Justify:=pjCenter;
  C.Border :=BOXLINELEFTRIGHT;

  { Unidade }
  C :=FColumns.Add;
  C.Caption:='UNID ADE';
  C.PosX   :=NA;
  C.Width  :=0.75;
  C.Justify:=pjCenter;
  C.Border :=BOXLINELEFTRIGHT;

  { Quantidade }
  C :=FColumns.Add;
  C.Caption :='QUANT IDADE';
  C.PosX   :=NA;
  C.Width  :=1.32;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor unitário }
  C :=FColumns.Add;
  C.Caption :='VALOR UNITÁRIO';
  C.PosX   :=NA;
  C.Width  :=1.27;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor desconto }
  C :=FColumns.Add;
  C.Caption :='VALOR DO DESCONTO';
  C.PosX   :=NA;
  C.Width  :=1.25;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor total }
  C :=FColumns.Add;
  C.Caption :='VALOR TOTAL';
  C.PosX   :=NA;
  C.Width  :=1.40;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Base de Cálculo do ICMS próprio }
  C :=FColumns.Add;
  C.Caption :='B.CÁLCULO DO ICMS';
  C.PosX   :=NA;
  C.Width  :=1.40;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Base de Cálculo do ICMS ST }
  C :=FColumns.Add;
  C.Caption :='B.CÁLCULO DO ICMS ST';
  C.PosX   :=NA;
  C.Width  :=1.40;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor do ICMS próprio }
  C :=FColumns.Add;
  C.Caption :='VALOR DO ICMS';
  C.PosX   :=NA;
  C.Width  :=1.30;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor do ICMS ST }
  C :=FColumns.Add;
  C.Caption :='VALOR DO ICMS ST';
  C.PosX   :=NA;
  C.Width  :=1.30;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Valor do IPI }
  C :=FColumns.Add;
  C.Caption :='VALOR DO IPI';
  C.PosX   :=NA;
  C.Width  :=1.00;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Aliquota do ICMS próprio }
  C :=FColumns.Add;
  C.Caption :='ALIQ. ICMS';
  C.PosX   :=NA;
  C.Width  :=0.96;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

  { Aliquota do IPI }
  C :=FColumns.Add;
  C.Caption :='ALIQ.  IPI';
  C.PosX   :=NA;
  C.Width  :=0.96;
  C.Justify:=pjRight;
  C.Border :=BOXLINELEFTRIGHT;

end;

destructor TdanfeBlcProd.Destory;
begin
  FColumns.Destroy ;
end;

procedure TdanfeBlcProd.DoPrint;
var
  det: TnfeDet ;
  pro: TnfeProduto; // Tprod;
  imp: TnfeImposto; // Timposto;
var
  CST:string;
  vBC:Currency	;
  pICMS:Currency;
  vICMS:Currency;
  vIPI,pIPI:Currency;

var
  H: Double;

{$REGION 'DoCabProd'}
  procedure DoCabProd;
  var
    C: TdanfeColumn ;
    I: Integer;
  begin
    with Owner do
    begin
      SetFont(FONT_SIZE_6); X :=Report.MarginLeft; Y :=Box.Bottom +DIST_IN_BLOCO;
      PrintXY(X, Y, 'DADOS DOS PRODUTOS/SERVIÇOS', pjLeft, [fsBold]);
      H :=2*Report.LineHeight;
      for I :=0 to Colunas.Count -1 do
      begin
        C :=Colunas.Items[I] ;
        if C.Visible then
        begin
          DrawBox(X, Y, C.Width, H);
          PrintBox(C.Caption +'#C', 0, 0, 10);
          X :=NA ;
        end;
      end;
      X :=Report.MarginLeft; Y :=Box.Bottom; Report.GotoXY(X, Y);
    end;
  end;
{$ENDREGION}

{$REGION 'DoPrintItem'}
  procedure DoPrintItem(const Show: Boolean; const BoxLine: Byte = BOXLINELEFTRIGHT);
  var
    fcProd: string ;
    fxProd: string ;
    fNCM: string ;
    fCST: string;
    fCFOP: string ;
    fuCom: string;
    fqCom: string ;
    fvUnCom: string;
    fvProd: string ;
    fvBC: string ;
    fvICMS: string ;
    fpICMS: string ;
    fvIPI: string ;
    fpIPI: string ;
  begin
    if Show then
    begin
      fcProd  :=pro.cProd;
      fxProd  :=' '+ Tnfeutil.ParseText(pro.xProd, True);
      fNCM    :=pro.NCM;
      fCST    :=CST;
      fCFOP   :=IntToStr(pro.CFOP);
      fuCom   :=pro.uCom;
      fqCom   :=Tnfeutil.FFlt(pro.qCom, '0.000'   )+' ';
      fvUnCom :=Tnfeutil.FCur(pro.vUnCom          )+' ';
      fvProd  :=Tnfeutil.FCur(pro.vProd	          )+' ';
      fvBC    :=Tnfeutil.FCur(vBC				          )+' ';
      fvICMS  :=Tnfeutil.FCur(vICMS			          )+' ';
      fpICMS  :=Tnfeutil.FFlt(pICMS			          )+' ';
      fvIPI   :=Tnfeutil.FCur(vIPI                )+' ';
      fpIPI   :=Tnfeutil.FFlt(pIPI                )+' ';
    end
    else begin
      fcProd  :='';
      fxProd  :='';
      fNCM    :='';
      fCST    :='';
      fCFOP   :='';
      fuCom   :='';
      fqCom   :='';
      fvUnCom :='';
      fvProd  :='';
      fvBC    :='';
      fvICMS  :='';
      fpICMS  :='';
      fvIPI   :='';
      fpIPI   :='';
    end;
    Owner.PrintTab(01, fcProd , BoxLine);
    Owner.PrintTab(02, fxProd , BoxLine);
    Owner.PrintTab(03, fNCM   , BoxLine);
    Owner.PrintTab(04, fCST   , BoxLine);
    Owner.PrintTab(05, fCFOP  , BoxLine);
    Owner.PrintTab(06, fuCom  , BoxLine);
    Owner.PrintTab(07, fqCom  , BoxLine);
    Owner.PrintTab(08, fvUnCom, BoxLine);
    Owner.PrintTab(09, fvProd , BoxLine);
    Owner.PrintTab(10, fvBC   , BoxLine);
    Owner.PrintTab(11, fvICMS , BoxLine);
    Owner.PrintTab(12, fvIPI  , BoxLine);
    Owner.PrintTab(13, fpICMS , BoxLine);
    Owner.PrintTab(14, fpIPI  , BoxLine);
  end;
{$ENDREGION}

var
  C,I: Integer ;

var
  infAdProd: string ;

begin

  infAdProd :='';
  DoCabProd; C :=0;
  with Owner do
  begin
    for I :=0 to NFe.det.Count -1 do
    begin

      det :=NFe.det.Items[I];
      pro :=det.prod;
      imp :=det.imposto;

      CST   :=IntToStr(Ord(imp.ICMS.orig)) + Tnfeutil.FInt(Ord(imp.ICMS.CST));
      vBC		:=imp.ICMS.vBC	;
      pICMS :=imp.ICMS.pICMS;
      vICMS :=imp.ICMS.vICMS;
      vIPI :=imp.IPI.vIPI ;
      pIPI :=imp.IPI.pIPI ;

      if Self.InfAdProd then
      begin
        if pro.cEAN <> '' then
        begin
          infAdProd :=Format('EAN: %s', [pro.cEAN]);
        end;
        if pro.med.nLote <> '' then
        begin
          if infAdProd <> '' then
            infAdProd :=infAdProd +Format('  Lot.Fab: %s', [pro.med.nLote])
          else
            infAdProd :=Format('Lot.Fab: %s', [pro.med.nLote]);
        end;
      end;

      //Quebra pag
      if(C = ItensPorPag) then
      begin
        BlcAdic.DoPrint;
        //
        SetFont(FONT_SIZE_10); X :=Box.Right; Y :=Box.Bottom +Report.FontHeight ;
        PrintXY(X, Y, 'CONTINUA NO VERSO', pjRight);
        Report.NewPage; X :=Report.MarginLeft; Y :=Report.MarginTop;
        //

        BlcCab.DoPrint ;
        DoCabProd;
        //
        C :=0;
        if Orientation = poLandScape then
        begin
          ItensPorPag :=36;
        end
        else begin
          ItensPorPag :=72;
        end;
      end;

      if Odd(I) then Report.TabShade :=20;

      SetFont(FONT_SIZE_6); Report.NewLine; Inc(C);
      Report.RestoreTabs(TAB_PROD);

      if C <> ItensPorPag then
      begin
        DoPrintItem(True);
      end
      else begin
        DoPrintItem(True, BOXLINENOTOP);
      end;
      Report.TabShade :=00;

      {if infAdProd <> '' then
      begin
        Report.NewLine;
        Report.RestoreTabs(TAB_PROD_LINEAD);
        Report.PrintTab('');
        Report.PrintTab(infAdProd);
      end;}

    end;

    if(ItensPorPag -C) > 0 then
    begin
      SetFont(FONT_SIZE_6);
      for I :=1 to (ItensPorPag -C) do
      begin
        Report.NewLine;
        Report.RestoreTabs(TAB_PROD);
        if I < (ItensPorPag -C) then
        begin
          DoPrintItem(False);
        end
        else begin
          DoPrintItem(False, BOXLINENOTOP);
        end;
      end;
    end;

  end;

end;

procedure TdanfeBlcProd.SetColumn(const Order: TdanfeProdColumn;
  const Caption: string;
  const PosX, Width: Double;
  const Just: TPrintJustify;
  const Border: Byte);
var
  C: TdanfeColumn ;
begin
  C :=FColumns.Items[Ord(Order)];
  if Assigned(C) then
  begin
    C.Caption :=Caption;
    C.PosX :=PosX ;
    C.Width :=Width ;
    C.Justify :=Just ;
    C.Border :=Border;
    C.Visible :=True ;
  end;
end;

procedure TdanfeBlcProd.SetColumns(const Value: TdanfeProdColumnSet);
var
  C: TdanfeColumn;
  I: Integer ;
begin
  FVisibleColumns :=Value;
  for I :=0 to FColumns.Count -1 do
  begin
    C :=FColumns.Items[I] ;
    C.Visible :=TdanfeProdColumn(C.Id) in FVisibleColumns ;
  end;
end;

{ TdanfeBlcAdic }

constructor TdanfeBlcAdic.Create(AOwner: TCustomDANFe);
begin
  Owner :=AOwner ;
  FPrintBloco :=True;
  QInfCpl :=TdanfeQuadro.Create ;
  QInfFis :=TdanfeQuadro.Create ;
end;

destructor TdanfeBlcAdic.Destory;
begin
  QInfCpl.Destroy;
  QInfFis.Destroy;
end;

procedure TdanfeBlcAdic.DoPrint;
begin
  with Owner do
  begin
    X :=Report.MarginLeft; Y :=Report.YPos +DIST_IN_BLOCO;
    PrintXY(X, Y, 'DADOS ADICIONAIS', pjLeft, [fsBold]); SetFont(FONT_SIZE_8);
    PQuadro(X, Y, QInfCpl, False);

    SetFont(FONT_SIZE_10); X :=Box.Left +Box.Width/2; Y :=Box.Bottom;
    PrintXY(X, Y, 'WWW.SUPORTWARE.COM.BR',pjCenter,[],clSilver);

    // msg contingência
    if NFe.ide.tpEmis in[emisCon_FS,emisCon_FSDA] then
    begin
      X :=Report.MarginLeft; Y :=Box.Bottom +Report.FontHeight;
      PrintXY(X,Y,'DANFE em contingência, impresso em decorrência de problemas técnicos!',pjLeft,[fsBold]);
    end
    else begin
      PQuadro(NA, Box.Top, QInfFis);
    end;
  end;
end;

{ TDANFeRetrato }

constructor TDANFeRetrato.Create(ANFe: TNFe; AinfProt: TinfProt);
begin
  inherited Create(poPortrait);

  NFe :=ANFe ;
  infProt :=AinfProt ;

  DoConfigBloco ;
  DoCreateColumnsCobr ;
  DoSetColumnsProd ;

end;

procedure TDANFeRetrato.DoConfigBloco;
const
  HCX_TEXT  = 0.85;
var
  txt: string;
  C: Integer ;
begin

{$REGION 'Bloco-Canhoto'}
  txt :=Tnfeutil.ParseText(NFe.emit.xNome, True) ;
  txt :=Format('RECEBEMOS DE (%s OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO)',[txt]);
  BlcCanhoto.QReceb    .DoConfig(HCX_TEXT, 16.10, txt                  );
  BlcCanhoto.QDataReceb.DoConfig(HCX_TEXT,  4.50, 'DATA DE RECEBIMENTO');
  BlcCanhoto.QAssina   .DoConfig(HCX_TEXT, 11.60, 'IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR');

  txt :='NF-e';
  txt :=txt +Format(#13'Nº: %s'    , [Tnfeutil.FormatDocFiscal(NFe.ide.nNF)]);
  txt :=txt +Format(#13'SERIE: %s' , [Tnfeutil.FInt(NFe.ide.serie,3)       ]);
  BlcCanhoto.QIdNFE.DoConfig(2*HCX_TEXT, 4.50, '', txt, pjCenter            );

{$ENDREGION}

{$REGION 'Bloco-cabeçalho'}
  BlcCab.QIdEmit.DoConfig(3.92, 10.00, 'IDENTIFICAÇÃO DO EMITENTE');
  BlcCab.QDanfe.DoConfig(3.92, 2.54, 'DANFE', 'DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA');
  BlcCab.QCodBar.DoConfig(1.50, 8.00);
  BlcCab.QChave.DoConfig(1.00, 8.00, 'CHAVE DE ACESSO', Tnfeutil.Ch_Format(NFe.Id));
  case NFe.ide.tpEmis of
    emisNomal,emisCon_SCAN:
    begin
      txt :='Consulta de autenticidade no portal nacional da NF-e ';
      txt :=txt +'www.nfe.fazenda.gov.br/portal ou no site da SEFAZ autorizadora';
      BlcCab.QCampo1.DoConfig(1.42, 8.00, '', txt);
      if infProt = nil then txt :=''
      else                  txt :=infProt.nProt +'  '+ Tnfeutil.FDat(infProt.dhRecbto,dpDateTime);
      BlcCab.QCampo2.DoConfig(HCX_TEXT, 8.00, 'PROTOCOLO DE AUTORIZAÇÃO DE USO', txt);
    end;
    emisCon_FS,emisCon_FSDA:
    begin
      txt :=NFe.SegCodBar ;
      BlcCab.QCampo1.DoConfig(1.42, 8.00, '', txt);
      BlcCab.QCampo2.DoConfig(HCX_TEXT, 8.00, 'DADOS DA NF-e', Tnfeutil.Ch_Format(txt,36));
    end;
  end;

  BlcCab.QNatOpe.DoConfig(HCX_TEXT, 12.54, 'NATUREZA DA OPERAÇÃO', NFe.ide.natOp);
  BlcCab.QIE.DoConfig(HCX_TEXT, 6.85, 'INSCRIÇÃO ESTADUAL DO EMITENTE', Tnfeutil.FormatIE(NFe.emit.IE,NFe.emit.ender.UF));
  BlcCab.QIEST.DoConfig(HCX_TEXT, 6.85, 'INSC. EST. DE SUBST. TRIBUTÁRIO DO EMITENTE', Tnfeutil.FormatIE(NFe.emit.IEST,NFe.emit.ender.UF));
  BlcCab.QCNPJ.DoConfig(HCX_TEXT, 6.85, 'CNPJ DO EMITENTE', Tnfeutil.FormatCNPJ(NFe.emit.CNPJ));
{$ENDREGION}

{$REGION 'Bloco-Destinatário/Remetente'}
  txt :=Tnfeutil.ParseText(NFe.dest.xNome, True);
  if NFe.emit.CNPJ<>'' then
  begin
    //Quadro Razão Social/cnpj
    BlcDestRem.QNome.DoConfig(HCX_TEXT, 12.54, 'RAZÃO SOCIAL', txt);
    BlcDestRem.QCnpj.DoConfig(HCX_TEXT, 4.46, 'C.N.P.J.', Tnfeutil.FormatCNPJ(NFe.dest.CNPJ), pjLeft, True);
  end
  else begin
    //Quadro Nome/cpf
    BlcDestRem.QNome.DoConfig(HCX_TEXT, 12.54, 'NOME', txt);
    BlcDestRem.QCnpj.DoConfig(HCX_TEXT, 4.46, 'C.P.F.', Tnfeutil.FormatCPF(NFe.dest.CPF), pjLeft, True);
  end;

  //Quadro data da emissão
  txt :=Tnfeutil.FDat(NFe.ide.dEmi);
  BlcDestRem.QDtEmis.DoConfig(HCX_TEXT, 2.92, 'DATA DA EMISSÃO', txt);

  //Quadro endereço
  txt :=Tnfeutil.ParseText(NFe.dest.ender.xLgr, True);
  BlcDestRem.QEnd.DoConfig(HCX_TEXT, 10.15, 'ENDEREÇO', txt);

  //Quadro Bairro/Distrito
  txt :=Tnfeutil.ParseText(NFe.dest.ender.xBairro, True);
  BlcDestRem.QBairro.DoConfig(HCX_TEXT, 4.85, 'BAIRRO/DISTRITO', txt);

  //Quadro CEP
  txt :=Tnfeutil.FormatCEP(NFe.dest.ender.CEP) ;
  BlcDestRem.QCEP.DoConfig(HCX_TEXT, 2.0, 'C.E.P.', txt);

  //Quadro data da entrada/saida
  txt :=Tnfeutil.FDat(NFe.ide.dSaiEnt) ;
  BlcDestRem.QDtEntSai.DoConfig(HCX_TEXT, 2.92, 'DATA DA ENTRADA/SAIDA', txt, pjLeft, True);

  //Quadro município
  txt :=Tnfeutil.ParseText(NFe.dest.ender.xMun, True);
  BlcDestRem.QMun.DoConfig(HCX_TEXT, 7.15, 'MUNICÍPIO', txt);

  //Quadro fone/fax
  txt :=Tnfeutil.FormatFone(NFe.dest.ender.fone) ;
  BlcDestRem.QFone.DoConfig(HCX_TEXT, 4.06, 'FONE/FAX', txt);

  //Quadro UF
  BlcDestRem.QUF.DoConfig(HCX_TEXT, 1.33, 'UF', NFe.dest.ender.UF);

  //Quadro inscrição estadual
  txt :=Tnfeutil.FormatIE(NFe.dest.IE,NFe.dest.ender.UF);
  BlcDestRem.QIE.DoConfig(HCX_TEXT, 4.46, 'INSCRIÇÃO ESTADUAL', txt);

  //Quadro hora da entrada/saida
  txt :=Tnfeutil.FDat(NFe.ide.hSaiEnt,dpTime) ;
  BlcDestRem.QHrEntSai.DoConfig(HCX_TEXT, 2.92, 'HORA DA ENTRADA/SAIDA', txt, pjLeft, True);

{$ENDREGION}

{$REGION 'Bloco-Cálculo do imposto'}
  BlcCalcImposto.QvBC.DoConfig    (HCX_TEXT, 4.12, 'BASE DE CÁLCULO DO ICMS'   , Tnfeutil.FCur(NFe.total.vBC)   , pjRight);
  BlcCalcImposto.QvICMS.DoConfig  (HCX_TEXT, 4.12, 'VALOR DO ICMS'             , Tnfeutil.FCur(NFe.total.vICMS) , pjRight);
  BlcCalcImposto.QvBCST.DoConfig  (HCX_TEXT, 4.12, 'BASE DE CÁLCULO DO ICMS ST', Tnfeutil.FCur(NFe.total.vBCST) , pjRight);
  BlcCalcImposto.QvST.DoConfig    (HCX_TEXT, 4.12, 'VALOR DO ICMS ST'          , Tnfeutil.FCur(NFe.total.vST  ) , pjRight);
  BlcCalcImposto.QvProd.DoConfig  (HCX_TEXT, 4.32, 'VALOR TOTAL DOS PRODUTOS'  , Tnfeutil.FCur(NFe.total.vProd) , pjRight);
  BlcCalcImposto.QvFrete.DoConfig (HCX_TEXT, 3.30, 'VALOR DO FRETE'            , Tnfeutil.FCur(NFe.total.vFrete), pjRight);
  BlcCalcImposto.QvSeg.DoConfig   (HCX_TEXT, 3.30, 'VALOR DO SEGURO'           , Tnfeutil.FCur(NFe.total.vSeg  ), pjRight);
  BlcCalcImposto.QvDesc.DoConfig  (HCX_TEXT, 3.30, 'DESCONTO'                  , Tnfeutil.FCur(NFe.total.vDesc ), pjRight);
  BlcCalcImposto.QvOutro.DoConfig (HCX_TEXT, 3.30, 'OUT. DESPESAS ACESSÓRIAS'  , Tnfeutil.FCur(NFe.total.vOutro), pjRight);
  BlcCalcImposto.QvIPI.DoConfig   (HCX_TEXT, 3.28, 'VALOR DO IPI'              , Tnfeutil.FCur(NFe.total.vIPI  ), pjRight);
  BlcCalcImposto.QvNF.DoConfig    (HCX_TEXT, 4.32, 'VALOR TOTAL DA NOTA'       , Tnfeutil.FCur(NFe.total.vNF   ), pjRight, True);
{$ENDREGION}

{$REGION 'Bloco-transportador/volumes transportados'}
  txt :=Tnfeutil.ParseText(NFe.transp.transporta.xNome, True) ;
  if NFe.transp.transporta.CNPJ <> '' then
  begin
    BlcTransp.QNome.DoConfig(HCX_TEXT, 9.02, 'RAZÃO SOCIAL', txt);
    BlcTransp.QCNPJ.DoConfig(HCX_TEXT, 3.94, 'C.N.P.J.', Tnfeutil.FormatCNPJ(NFe.transp.transporta.CNPJ));
  end
  else begin
    BlcTransp.QNome.DoConfig(HCX_TEXT, 9.02, 'NOME', txt);
    BlcTransp.QCNPJ.DoConfig(HCX_TEXT, 3.94, 'C.P.F.', Tnfeutil.FormatCPF(NFe.transp.transporta.CPF));
  end;
  case NFe.transp.modFrete of
    freEmit:txt :='0-Emitente';
    freDest:txt :='1-Dest/Rem';
    freTerc:txt :='2-Terceiros';
  else
    txt :='9-Sem Frete';
  end;
  BlcTransp.QFrete.DoConfig(HCX_TEXT, 2.79, 'FRETE POR CONTA DE', txt);
  BlcTransp.QCodANTT.DoConfig(HCX_TEXT, 1.78, 'CÓDIGO ANTT', NFe.transp.veicTransp.RNTC);
  BlcTransp.QPlcNum.DoConfig(HCX_TEXT, 2.29, 'PLACA DO VEÍCULO.', Tnfeutil.FormatPlaca(NFe.transp.veicTransp.placa));
  BlcTransp.QPlcUF.DoConfig(HCX_TEXT, 0.76, 'UF', NFe.transp.veicTransp.UF);

  txt :=Tnfeutil.ParseText(NFe.transp.transporta.xEnder, True) ;
  BlcTransp.QEnd.DoConfig(HCX_TEXT, 9.02, 'ENDEREÇO', txt);
  txt :=Tnfeutil.ParseText(NFe.transp.transporta.xMun, True) ;
  BlcTransp.QMun.DoConfig(HCX_TEXT, 6.86, 'MUNICÍPIO', txt);
  BlcTransp.QUF.DoConfig(HCX_TEXT, 0.76, 'UF', NFe.transp.transporta.UF);
  txt :=Tnfeutil.FormatIE(NFe.transp.transporta.IE,NFe.transp.transporta.UF) ;
  BlcTransp.QIE.DoConfig(HCX_TEXT, 3.94, 'INSCRIÇÃO ESTADUAL', txt);

  BlcTransp.QQtdVol.DoConfig(HCX_TEXT, 2.92, 'QUANTIDADE DE VOLUMES', Tnfeutil.FFlt(NFe.transp.vol.qVol,'0'), pjRight);
  BlcTransp.QEsp.DoConfig(HCX_TEXT, 3.05, 'ESPÉCIE', NFe.transp.vol.esp);
  BlcTransp.QMarca.DoConfig(HCX_TEXT, 3.05, 'MARCA', NFe.transp.vol.marca);
  BlcTransp.QNum.DoConfig(HCX_TEXT, 4.83, 'NUMERAÇÃO');
  BlcTransp.QPesoBrt.DoConfig(HCX_TEXT, 3.43, 'PESO BRUTO'  , Tnfeutil.FFlt(NFe.transp.vol.pesoB,'0.000'), pjRight);
  BlcTransp.QPesoLiq.DoConfig(HCX_TEXT, 3.30, 'PESO LÍQUIDO', Tnfeutil.FFlt(NFe.transp.vol.pesoL,'0.000'), pjRight);

{$ENDREGION}

{$REGION 'Bloco-dados adicionais'}
  txt :='';
  if NFe.infAdic.infCpl<>'' then
  begin
    txt :=Tnfeutil.ParseText(NFe.infAdic.infCpl, True);
    for C :=1 to Length(txt) do
    begin
      if txt[C]=';' then txt[C]:=#13;
    end;
  end;

  //29.05.2013-Valor total aproximado dos tributos(NT2013.003)
  if NFe.total.vTotTrib > 0 then
  begin
    txt :=txt +#13'Valor total aproximado dos tributos: '+Tnfeutil.FCur(NFe.total.vTotTrib ) ;
  end;

  // msg contingência
  if NFe.ide.tpEmis = emisCon_FS then
  begin
    txt :=txt +#13'Contingência em ';
    txt :=txt +FormatDateTime('dd/mm/yyyy hh:nn:ss', NFe.ide.dhCont);
    txt :=txt +' '+NFe.ide.xJust;
  end ;
  BlcAdic.QInfCpl.DoConfig(3.07, 12.95, 'INFORMAÇÕES COMPLEMENTARES', txt);
  BlcAdic.QInfFis.DoConfig(3.07, 7.62, 'RESERVADO AO FISCO');

{$ENDREGION}

end;

procedure TDANFeRetrato.DoCreateColumnsCobr;
var
  col: TdanfeColumn;

begin
  //Número
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=MarginLeft;
  col.Width  :=3.21;

  //Data do Vencimento
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=NA;
  col.Width  :=3.42;

  //Valor
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=NA;
  col.Width  :=3.00;
  col.Justify:=pjRight;

  //Número
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=10.50;
  col.Width  :=3.21;

  //Data do Vencimento
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=NA;
  col.Width  :=3.42;

  //Valor
  col :=BlcFatDups.Colunas.Add;
  col.PosX   :=NA;
  col.Width  :=3.00;
  col.Justify:=pjRight;

end;

procedure TDANFeRetrato.DoPrint(Sender: TObject);
begin
  ItensPorPag :=36;

  if BlcCanhoto.PrintBloco then
  begin
    BlcCanhoto.DoPrint ;
    ItensPorPag :=30;
  end;

  BlcCab.DoPrint ;
  BlcDestRem.DoPrint ;

  if BlcFatDups.PrintBloco and(NFe.cobr.dup.Count > 0) then
  begin
    BlcFatDups.DoPrint ;
    ItensPorPag :=26;
  end;

  BlcCalcImposto.DoPrint;
  BlcTransp.DoPrint;
  BlcProd.DoPrint ;
  BlcAdic.DoPrint ;
end;

procedure TDANFeRetrato.DoSetColumnsProd;
begin
  BlcProd.SetColumn(pcCProd   , 'CODIGO PRODUTO', MarginLeft, 1.27      , pjCenter);
  BlcProd.SetColumn(pcXProd   , 'DESCRIÇÃO DO PRODUTO/SERVIÇO', NA, 5.83, pjLeft );
  BlcProd.SetColumn(pcNCM     , 'NCM/SH'                      , NA, 1.25, pjCenter);
  BlcProd.SetColumn(pcCST     , 'CST'                         , NA, 0.56, pjCenter);
  BlcProd.SetColumn(pcCFOP    , 'CFOP'                        , NA, 0.76, pjCenter);
  BlcProd.SetColumn(pcUnid    , 'UNID ADE'                    , NA, 0.75, pjCenter);
  BlcProd.SetColumn(pcQtde    , 'QUANT IDADE'                 , NA, 1.32, pjRight);
  BlcProd.SetColumn(pcVUnit   , 'VALOR UNITÁRIO'              , NA, 1.27, pjRight);
  BlcProd.SetColumn(pcVTot    , 'VALOR TOTAL'                 , NA, 1.40, pjRight);
  BlcProd.SetColumn(pcVBC     , 'B.CÁLCULO DO ICMS'           , NA, 1.40, pjRight);
  BlcProd.SetColumn(pcVICMS   , 'VALOR DO ICMS'               , NA, 1.30, pjRight);
  BlcProd.SetColumn(pcVIPI    , 'VALOR DO IPI'                , NA, 0.96, pjRight);
  BlcProd.SetColumn(pcAliqICMS, 'ALIQ. ICMS'                  , NA, 0.96, pjRight);
  BlcProd.SetColumn(pcAliqIPI , 'ALIQ.  IPI'                  , NA, 0.96, pjRight);
end;

{ TDANFePaisagem }

constructor TDANFePaisagem.Create(ANFe: TNFe; AinfProt: TinfProt);
begin
  inherited Create(poLandScape);

  NFe :=ANFe ;
  infProt :=AinfProt ;

  DoConfigBloco ;
  DoCreateColumnsCobr ;
  DoCreateColumnsProd ;

  ItensPorPag :=20;

end;

procedure TDANFePaisagem.DoConfigBloco;
const
  HCX_TEXT  = 0.85;
var
  txt: string;
  C: Integer ;
begin

{$REGION 'Bloco-Canhoto'}
  txt :='NF-e';
  txt :=txt +Format(#13'Nº: %s'    , [Tnfeutil.FormatDocFiscal(NFe.ide.nNF)]);
  txt :=txt +Format(#13'SÉRIE: %s' , [Tnfeutil.FInt(NFe.ide.serie,3     )]);

  BlcCanhoto.QIdNFE.DoConfig(4.53, 2.03, '', txt, pjCenter, False, 90);

  txt :=Tnfeutil.ParseText(NFe.emit.xNome, True) ;
  txt :=Format('RECEBEMOS DE (%s OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO)',[txt]);

  BlcCanhoto.QReceb    .DoConfig(16.95, 1.02, txt, '', pjLeft, False, 90);
  BlcCanhoto.QAssina   .DoConfig(9.21, 1.02, 'IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR', '', pjLeft, False, 90);
  BlcCanhoto.QDataReceb.DoConfig(6.75, 1.02, 'DATA DE RECEBIMENTO', '', pjLeft, False, 90);

{$ENDREGION}
end;

procedure TDANFePaisagem.DoCreateColumnsCobr;
begin

end;

procedure TDANFePaisagem.DoCreateColumnsProd;
begin

end;

procedure TDANFePaisagem.DoPrint(Sender: TObject);
begin

  ItensPorPag :=36;

  if BlcCanhoto.PrintBloco then
  begin
    BlcCanhoto.DoPrintLandScape;
    ItensPorPag :=30;
  end;

{  BlcCab.DoPrint ;
  BlcDestRem.DoPrint ;

  if BlcFatDups.PrintBloco and(NFe.cobr.dup.Count > 0) then
  begin
    BlcFatDups.DoPrint ;
    FItensPorPag :=26;
  end;

  BlcCalcImposto.DoPrint;
  BlcTransp.DoPrint ;
  BlcProd.DoPrint ;
  BlcAdic.DoPrint ;
}
end;


{$IFDEF NFCE}

{ TDANFe_NFCe }

function TDANFe_NFCe.cHashQRCode: string;
begin
  Result :=QRCode(True) ;
  Result :=TDCP_sha1.Execute(Result) ;
end;

constructor TDANFe_NFCe.Create(ANFe: TNFe; AinfProt: TinfProt);
begin
  inherited Create(poPortrait);

  NFe :=ANFe ;
  infProt :=AinfProt;

  MarginTop :=2.54;
  MarginBottom :=2.54;
  MarginLeft :=2.54;
  MarginRight :=2.54;

  DoSetColumnsProd;

  Image :=TImage.Create(nil) ;

  Barcode :=TpsBarcodeComponent.Create(nil);
  Barcode.BarcodeSymbology :=bcQRCode ;
  Barcode.Params.QRCode.EccLevel  :=QrEccLevelM ;
  Barcode.Params.QRCode.Version   :=100;

end;

destructor TDANFe_NFCe.Destroy;
begin
  Image.Destroy ;
  Barcode.Destroy ;
  inherited Destroy ;
end;

procedure TDANFe_NFCe.DoPrint(Sender: TObject);
const
  HCX_CAB = 1.30;
  HCX_TOT = 2.20;
  HCX_TRIB= 0.60;
  HCX_DOC = 3.00;
  HCX_QRCODE =3.50;

var
  X,Y: Double;

var
  txt: string;
  I: Integer;
  P: TnfePgto;
  det: TnfeDet ;
  C: TdanfeColumn;
  Items: Integer ;
  //
{$REGION 'DoCab'}
  procedure DoCab;
  begin
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;

    Report.SetFont(FONT_TIMES_NW, FONT_SIZE_10);

    //Divisão I - Cabeçalho
    txt :=Tnfeutil.ParseText(NFe.emit.xNome, True);
    txt :=txt +#13'CNPJ: ' +Tnfeutil.FormatCNPJ(NFe.emit.CNPJ) +DupeString(' ', 10);
    txt :=txt +'IE:' +Tnfeutil.FormatIE(NFe.emit.IE, NFe.emit.ender.UF) ;
    txt :=txt +#13 +Tnfeutil.ParseText(NFe.emit.ender.xLgr, True);
    txt :=txt +', ' +Tnfeutil.ParseText(NFe.emit.ender.xBairro, True);
    txt :=txt +', ' +Tnfeutil.ParseText(NFe.emit.ender.xMun   , True);
    txt :=txt +'-'+ NFe.emit.ender.UF;
    txt :=txt +'  CEP: '+ Tnfeutil.FormatCEP(NFe.emit.ender.CEP);

    DrawBox(X, Y, Report.SectionRight, HCX_CAB, 0.10, 0, pjLeft, [fsBold]); X :=2;
    PrintBox(txt, X, 0);

    if Assigned(BlcCab.FBitmap) then
    begin
      X :=Box.Left +Box.Margin; Y :=Box.Top +0.10; // Report.LineTop ;
      Report.PrintBitmapRect(X, Y, X +1.80, Y +3*Report.LineHeight -0.10, BlcCab.FBitmap);
    end;

    X :=Report.MarginLeft;

    //Divisão II - Informações Fixas do DANFE NFC-e
    txt :='DANFE NFC-e - Documento Auxiliar'#13;
    txt :=txt +'da Nota Fiscal Eletrônica para Consumidor Final'#13;
    txt :=txt +'Não permite aproveitamento de crédito de ICMS';
    DrawBox(X, NA, Box.Width, HCX_CAB, 0, 0, pjCenter, [fsBold]); X :=0;
    PrintBox(txt, 0, 0);

    X :=Report.MarginLeft;
    Y :=Box.Bottom;
  end;
{$ENDREGION}

{$REGION 'DoCabProd'}
  procedure DoCabProd;
  var
    I: Integer;
  begin
    SetFont(FONT_COURIER_NW);
    Report.GotoXY(X, Y); Report.NewLine; Report.RestoreTabs(TAB_PROD) ;
    Report.TabShade :=10;
    for I :=0 to BlcProd.Colunas.Count -1 do
    begin
      C :=BlcProd.Colunas.Items[I] ;
      if C.Visible then
      begin
        Report.PrintTab(BlcProd.Colunas.Items[I].Caption);
      end;
    end;
    Report.TabShade :=00;
  end;
{$ENDREGION}

{$REGION 'DoTotal'}
  procedure DoTotal;
  var
    I: Integer;
  begin
    DrawBox(X, Y, Box.Width, HCX_TOT, 0.10);
    PrintBox('QTD. TOTAL DE ITENS', 0, 0); X :=1.0; Y :=Report.LineHeight;
    PrintBox(IntToStr(NFe.det.Count)+'#R;[B]', X, 0);
    PrintBox('VALOR TOTAL R$', 0, 2*Y);
    PrintBox(Tnfeutil.FCur(NFe.total.vProd) +'#R;[B]', X, 2*Y);
    PrintBox('FORMA DE PAGAMENTO', 0, 3*Y); X :=0.50 ;
    PrintBox('Valor Pago#R', X, 3*Y); X :=1.0;
    for I :=0 to NFe.pag.Count -1 do
    begin
      P :=NFe.pag.Items[I] ;
      case P.tPag of
        fpDinheiro: txt :='Dinheiro';
        fpCheque: txt :='Cheque';
        fpCrtCre: txt :='Cartão de Crédito';
        fpCrtDeb: txt :='Cartão de Débito';
        fpCrtLoja: txt :='Cartão Loja';
        fpValAlimenta: txt :='Vale Alimentação';
        fpValRefeicao: txt :='Vale Refeição';
        fpValPresente: txt :='Vale Presente';
        fpValCombust: txt :='Vale Combustivel';
        fpOutros: txt :='Outros';
      end;
      PrintBox(txt, 0, (I+4)*Y) ;
      PrintBox(Tnfeutil.FCur(P.vPag) +'#R;[B]', X, (I+4)*Y);
    end;
  end;

{$ENDREGION}

var
  R:TRect ;

begin

  ItensPorPag :=54;
  DoCab ;

  //Divisão III – Detalhe da Venda
  if BlcProd.PrintBloco then
  begin

    DoCabProd;
    Items :=0;

    for I :=0 to NFe.det.Count -1 do
    begin
      det  :=NFe.det.Items[I];

      //Quebra pag
      if(Items = ItensPorPag) then
      begin
        Report.NewPage;
        DoCabProd;
        Items :=0;
        ItensPorPag :=62;
      end;

      Report.NewLine; Inc(Items) ;
      Report.RestoreTabs(TAB_PROD);

      if Odd(I) then Report.TabShade :=10;
      if I < NFe.det.Count -1 then
      begin
        Report.PrintTab(det.prod.cProd                          );
        Report.PrintTab(Tnfeutil.ParseText(det.prod.xProd, True));
        Report.PrintTab(det.prod.uCom                           );
        Report.PrintTab(Tnfeutil.FFlt(det.prod.qCom, '0,000'   ));
        Report.PrintTab(Tnfeutil.FCur(det.prod.vUnCom          ));
        Report.PrintTab(Tnfeutil.FCur(det.prod.vProd           )+' ');
      end
      else begin
        PrintTab(1, det.prod.cProd                          , BOXLINELEFTBOTTOM);
        PrintTab(2, Tnfeutil.ParseText(det.prod.xProd, True), BOXLINEBOTTOM);
        PrintTab(3, det.prod.uCom                           , BOXLINEBOTTOM);
        PrintTab(4, Tnfeutil.FFlt(det.prod.qCom, '0,000'   ), BOXLINEBOTTOM);
        PrintTab(5, Tnfeutil.FCur(det.prod.vUnCom          ), BOXLINEBOTTOM);
        PrintTab(6, Tnfeutil.FCur(det.prod.vProd           )+' ', BOXLINERIGHTBOTTOM);
      end;
      Report.TabShade :=00;

    end;
    Y :=Report.LineBottom;
  end;

  if Report.YPos + HCX_TOT > Report.SectionBottom then
  begin
    Report.NewPage;
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;
  end;

  //Divisão IV – Informações de Total do DANFE NFC-e
//  DoTotal ;
  DrawBox(X, Y, Box.Width, 2.20, 0.10);
  PrintBox('QTD. TOTAL DE ITENS', 0, 0); X :=1.0; Y :=Report.LineHeight;
  PrintBox(IntToStr(NFe.det.Count)+'#R;[B]', X, 0);
  PrintBox('VALOR TOTAL ', 0, 2*Y);
  PrintBox(Tnfeutil.FCur(NFe.total.vProd,True) +'#R;[B]', X, 2*Y);
  PrintBox('FORMA DE PAGAMENTO', 0, 3*Y); X :=0.50 ;
  PrintBox('Valor Pago#R', X, 3*Y); X :=1.0;
  for I :=0 to NFe.pag.Count -1 do
  begin
    P :=NFe.pag.Items[I] ;
    case P.tPag of
      fpDinheiro: txt :='Dinheiro';
      fpCheque: txt :='Cheque';
      fpCrtCre: txt :='Cartão de Crédito';
      fpCrtDeb: txt :='Cartão de Débito';
      fpCrtLoja: txt :='Cartão Loja';
      fpValAlimenta: txt :='Vale Alimentação';
      fpValRefeicao: txt :='Vale Refeição';
      fpValPresente: txt :='Vale Presente';
      fpValCombust: txt :='Vale Combustivel';
      fpOutros: txt :='Outros';
    end;
    PrintBox(txt, 0, (I+4)*Y) ;
    if P.tPag = fpDinheiro then
      PrintBox(Tnfeutil.FCur(P.vPag,True) +'#R;[B]', X, (I+4)*Y)
    else
      PrintBox(Tnfeutil.FCur(P.vPag) +'#R;[B]', X, (I+4)*Y);
  end;

  X :=Report.MarginLeft; Y :=Box.Bottom;
  SetFont(FONT_TIMES_NW);

  if Box.Bottom + HCX_TRIB > Report.SectionBottom then
  begin
    Report.NewPage;
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;
  end;

  //Divisão V – Informações dos Tributos no DANFE NFC-e
  DrawBox(X, Y, Box.Width, HCX_TRIB, 0.10); X :=0.50; Y :=Report.LineHeight;
  PrintBox('Informação dos Tributos Totais Incidentes (Lei Federal 12.741 /2012)', 0, Y);
  PrintBox(Tnfeutil.FCur(NFe.total.vTotTrib) +'#R;[B]', X, Y);

  X :=Report.MarginLeft; Y :=Box.Bottom;

  if NFe.ide.tpAmb = ambHom then
    txt :='EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO – SEM VALOR FISCAL'
  else begin
    case NFe.ide.tpEmis of
      emisNomal: txt :='PRODUÇÃO';
      emisCon_NFCe: txt :='EMITIDA EM CONTINGÊNCIA';
    else
      txt :='TIPO DE EMISSÃO NÃO SUPORTADO PARA A NFC-e!' ;
    end;
  end;

  if Box.Bottom + HCX_DOC > Report.SectionBottom then
  begin
    Report.NewPage;
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;
  end;

  //Divisão VI  –  Mensagem Fiscal e  Informações da  Consulta via  Chave de Acesso
  txt :=txt +#13'Número: '+ Tnfeutil.FormatDocFiscal(NFe.ide.nNF) ;
  txt :=txt +'  Série: '+ Tnfeutil.FInt(NFe.ide.serie, 3);
  txt :=txt +'  Emissão: '+ Tnfeutil.FDat(NFe.ide.dEmi +NFe.ide.hSaiEnt, dpDateTime);
  txt :=txt +#13 +Format('Consulte pela Chave de Acesso em %s',[Url]);
  txt :=txt +#13'CHAVE DE ACESSO';
  txt :=txt +#13 +Tnfeutil.Ch_Format(NFe.Id) ;
  DrawBox(X, Y, Box.Width, HCX_DOC, 0.10, 0, pjCenter, [fsBold]);
  PrintBox(txt, 0, 0, 4);
  {DrawBox(X, Y, Box.Width, HCX_DOC, 0.10, 0, pjCenter, [fsBold]);
  PrintBox(txt, 0, 0); Y :=Report.LineHeight;
  txt :='Número: '+ Tnfeutil.FormatDocFiscal(NFe.ide.nNF) ;
  txt :=txt +'  Série: '+ Tnfeutil.FInt(NFe.ide.serie, 3);
  txt :=txt +'  Emissão: '+ Tnfeutil.FDat(NFe.ide.dEmi +NFe.ide.hSaiEnt, dpDateTime);
  PrintBox(txt, 0, 2*Y);
  PrintBox(Format('Consulte pela Chave de Acesso em %s',[Url]), 0, 3*Y);
  PrintBox('CHAVE DE ACESSO', 0, 4*Y);
  PrintBox(Tnfeutil.Ch_Format(NFe.Id) +'#C;[B]', 0, 5*Y);}

  X :=Report.MarginLeft; Y :=Box.Bottom;

  if Box.Bottom + HCX_CAB > Report.SectionBottom then
  begin
    Report.NewPage;
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;
  end;

  //Divisão VII – Informações sobre o Consumidor
  txt :='';
  if NFe.Dest.CNPJ<>''    then
    txt :=Tnfeutil.FormatCNPJ(NFe.dest.CNPJ)
  else if NFe.Dest.CPF<>''then
    txt :=Tnfeutil.FormatCPF(NFe.dest.CPF)
  else
    txt :=NFe.dest.idEstrangeiro;
  if txt <> '' then
    txt :=Format('CONSUMIDOR'#13'CNPJ/CPF/ID Estrangeiro: %s', [txt])
  else
    txt :='CONSUMIDOR'#13'CONSUMIDOR NÃO IDENTIFICADO';
  DrawBox(X, Y, Box.Width, HCX_CAB, 0, 0, pjCenter, [fsBold]);
  PrintBox(txt, 0, 0);

  X :=Report.MarginLeft; Y :=Box.Bottom;

  if Box.Bottom + HCX_QRCODE > Report.SectionBottom then
  begin
    Report.NewPage;
    X :=Report.MarginLeft;
    Y :=Report.MarginTop ;
  end;

  //Divisão VIII – Informações da Consulta via QR Code
  DrawBox(X, Y, Box.Width, HCX_QRCODE, 0.10, 0, pjCenter, [fsBold]);
  PrintBox('Consulte via leitor de QR Code', 0, 0);

  R :=Report.CreateRect(0, 0, 2.54, 2.54);
  Image.Width :=R.Right; // Report.XU2D(2.54);
  Image.Height:=R.Bottom; // Report.YU2D(2.54);

  Barcode.BarCode :=Url +QRCode(False) +Format('&cHashQRCode=%s', [cHashQRCode]) ;
  Barcode.PaintBarCode(Image.Canvas, R);

  if Assigned(infProt) then
  begin
    txt:=Format('Protocolo de Autorização: %s  ',[infProt.nProt]);
    txt:=txt +Tnfeutil.FDat(infProt.dhRecbto, dpDateTime);
  end
  else begin
    txt:='Protocolo de Autorização: inexistente!';
  end;

  X :=Box.Left +(Box.Width -2.54)/2;
  Y :=Box.Top +Report.LineHeight +0.05 ;

  Report.PrintBitmapRect(X, Y, X+2.54, Y+2.54, Image.Picture.Bitmap);
  PrintBox(txt, 0, Box.Height -0.10);

end;

procedure TDANFe_NFCe.DoSetColumnsProd;
begin
  BlcProd.SetColumn(pcCProd, 'Código', MarginLeft,  2.00, pjCenter, BOXLINELEFT);
  BlcProd.SetColumn(pcXProd, 'Descrição', NA, 6.92, pjLeft, BOXLINENONE);
  BlcProd.SetColumn(pcQtde, 'Qtde', NA, 2.00, pjRight, BOXLINENONE);
  BlcProd.SetColumn(pcUnid, 'Unid', NA, 1.00, pjCenter, BOXLINENONE);
  BlcProd.SetColumn(pcVUnit, 'V.Unit', NA, 2.00, pjRight, BOXLINENONE);
  BlcProd.SetColumn(pcVTot, 'V.Total ', NA, 2.00, pjRight, BOXLINERIGHT);
end;

function TDANFe_NFCe.GetUrl: string;
begin
  if NFe.ide.tpAmb = ambPro then
    Result :='http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?'
  else
    Result :='http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?';
end;

function TDANFe_NFCe.QRCode(const FullToken: Boolean): string;
var
  S: string;
begin
  Result :=Format('chNFe=%s&', [NFe.Id]) ;
  Result :=Result +Format('nVersao=%d&', [Barcode.Params.QRCode.Version]) ;
  Result :=Result +Format('tpAmb=%d&', [Ord(NFe.ide.tpAmb)+1]) ;
  S :=NFe.dest.GetDoc ;
  if S <> '' then
  begin
    Result :=Result +Format('cDest=%s&', [S]) ;
  end;
  S :=Tnfeutil.FDat(NFe.ide.dEmi, dpDateTime, True) ;
  Result :=Result +Format('dhEmi=%s&', [StrToHex(S)]) ;
  Result :=Result +Format('vNF=%s&', [Tnfeutil.FFlt(NFe.total.vNF,'0.00')]) ;
  Result :=Result +Format('vICMS=%s&', [Tnfeutil.FFlt(NFe.total.vICMS,'0.00')]);
  Result :=Result +Format('digVal=%s&', [StrToHex(infProt.digVal)]) ;
  if FullToken then
  begin
    S :=LocalConfigNFe.emit.IdToken +
        Copy(NFe.emit.CNPJ, 1, 8) +
        IntToStr(YearOf(NFe.ide.dEmi)) +
        Copy(LocalConfigNFe.emit.IdToken, 3, 4);
  end
  else begin
    S :=LocalConfigNFe.emit.IdToken;
  end;
  Result :=Result +Format('cIdToken=%s', [S]) ;
end;

{$ENDIF}

begin
  RpDefine.DataID :=IntToStr(HInstance);
end.
