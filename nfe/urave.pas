unit urave;

interface

uses Windows    ,
    Messages    ,
    SysUtils    ,
    Classes     ,
    Graphics		,
    Printers		,
    jpeg        ,

    // RAVE
    RpBase      ,
    RpDefine    ,
    RpDevice    ,
    RpFiler			,
    RpSystem    ,
    RpRender    ,
    RpRenderText,
    RpRenderPDF ,
    rpBars

//    RpRave      ,
//    RpCon       ,
//    RpConDS     ,
//    RvLDCompiler,
//    RVProj      ,
//    RVCsStd     ,
//    RVClass     ,
//    rvcsrpt     ,
//    rvcsData    ,
//    rvData
    ;

type
  ERvError = class(Exception);

  TRvOrientation = type TOrientation;
  TRvDestination = type TReportDest;

  TRvRenderOutput = (roText, roPDF, roHTML, roNone) ;
  TRvRenderOutputFile = (rofText, rofPDF, rofHTML, rofNone) ;

  TRvBox = class
  public
    Left,Top: Double;
    Width: Double;
    Height: Double;
    Margin: Double; // Margem X(left, right) do box
    Shade: Byte;
    Justify: TPrintJustify;
    JustifyVert: TPrintJustifyVert;
    Styles: TFontStyles;
    Color: TColor ;
    function Right: Double;
    function Bottom: Double;
    procedure SetBox(const AMargin: Double); overload ;
    procedure SetBox(const AJust: TPrintJustify); overload;
    procedure SetBox(const AShade: Byte); overload;
  public
    constructor Create();
  end;

  TRvCustomCodBase = class(TRvSystem)
    procedure DoInit(Sender: TObject); virtual;
    procedure DoPrint(Sender: TObject); virtual; abstract ;
    procedure DoDecodeImage(Sender: TObject; ImageStream: TStream;
                            ImageType: String; Bitmap: Graphics.TBitmap); virtual;
  private
    FPrinterName: string;
    FCopies: Integer;

    FMarginLeft: Double ;
    FMarginRight: Double;
    FMarginTop: Double;
    FMarginBottom: Double;

  protected
    Report: TBaseReport;
    Units: TPrintUnits; { Units type }
    UnitsFactor: Double; { Units factor }

    Orientation: TRvOrientation;
    PaperSize  : Byte;
    PaperHeight: Double;
    PaperWidth: Double;

    RenderPDF: TRvRenderPDF;
    Box: TRvBox;

    procedure DrawLine(const X1, Y1, X2, Y2: Double; const Style: TPenStyle = psSolid);
    procedure DrawLineHorz(const PosY: Double; const Style: TPenStyle = psSolid);
    procedure DrawLineVert(const PosX: Double; const Style: TPenStyle = psSolid);
    procedure DrawBox(const NewX, NewY, NewWidth, NewHeight: Double;
                      const NewMargin: Double = 0;
                      const NewShade: Byte = 0;
                      const NewJustify: TPrintJustify = pjLeft;
                      const NewStyles: TFontStyles = []);

    procedure PrintBox(const Text: string;
      const X, Y: Double;
      const LinesPerInch: Integer =6); overload;

    procedure PrintBox(const X, Y: Double;
      const Text: string;
      const Style: TFontStyles =[];
      const LinesPerInch: Integer =6); overload;

    procedure PrintBarCod128(const CodBar: string; const X, Y: Double;
      const BarH: Double = 2.00;
      const BarW: Double = 0.03);

    procedure PrintXY(const X, Y: Double;
      const Text: string;
      const Justify: TPrintJustify = pjLeft;
      const Styles: TFontStyles = [];
      const Color: TColor = clNone;
      const Width: Double = 0.00);

    procedure PrintTab(const Index: Integer;
                       const Text: string;
                       const BoxLine: Byte);

    procedure NewLines(const Lines: Integer; const FontName: String = ''; FontSize: Double =0);
    procedure SetFont(const NewName: String; const NewSize: Double); overload ;
    procedure SetFont(const NewName: String); overload ;
    procedure SetFont(const NewSize: Double); overload ;

  public
    property PrinterName: string read FPrinterName write FPrinterName;
    property Copies: Integer read FCopies write FCopies;

    property MarginTop: Double read FMarginTop write FMarginTop;
    property MarginBottom: Double read FMarginBottom write FMarginBottom;
    property MarginLeft: Double read FMarginLeft write FMarginLeft;
    property MarginRight: Double read FMarginRight write FMarginRight;

    constructor Create(const AOrientation: TRvOrientation;
      const APaperSize: Byte =DMPAPER_A4;
      const APaperWidth: Double =21.0;
      const APaperHeight: Double =29.7;
      const AUnits: TPrintUnits = unCM;
      const AUnitsFactor: Double= 2.54); reintroduce;
    destructor Destroy; override ;

    procedure DoExecute(const Dest: TRvDestination;
      const RenderOutput: TRvRenderOutput = roNone); virtual ;

  public
    function FormatNumPage(const AFormat: string): string;
  end;

  TRvCodBasePortrait = class(TRvCustomCodBase)
  private
  protected
  public
    constructor Create(); reintroduce;
    destructor Destroy; override;
  end;

  TRvCodBaseLandScape = class(TRvCustomCodBase)
  private
  protected
  public
    constructor Create(); reintroduce;
    destructor Destroy; override;
  end;

//  TRvCodBaseCustom = class(TRvCustomCodBase)
//  private
//  protected
//  public
//    constructor Create(); reintroduce;
//    destructor Destroy; override;
//  end;



type

    TReportHeader = record
    public
      empresa_logo: TBitmap;
      empresa_nome: string;
      titulo_linha01: string;
      titulo_linha02: string;
      titulo_linha03: string;
      font_name: string;
      font_size: Integer;
    end;

    TReportFooter = record
    public
      unit_nome: string;
      unit_just: TPrintJustify;
      user_desc: string;
      user_just: TPrintJustify;
    end;

    TReportFont = class
    public
      const Arial       = 'Arial';
      const Times_NR    = 'Times New Roman';
      const Courier_Nw  = 'Courier New';
      const Size_6 = 6.0;
      const Size_7 = 7.0;
      const Size_8 = 8.0;
      const Size_9 = 9.0;
      const Size_10 = 10.0;
      const Size_12 = 12.0;
      const Size_14 = 14.0;
    end;

    TFormatFont = record
    public
      Color: TColor;
      Name: TFontName ;
      Size: Double  ;
      Style: TFontStyles;
      procedure Assign(AFormatFont: TFormatFont);
    end;

    TFormatText = record
    public
      Text: string  ;
      Justify: TPrintJustify;
      Font: TFormatFont  ;
      //Align:
      procedure SetText(const AText: string;
                        const AJust: TPrintJustify=pjLeft;
                        const AFontName: TFontName = TReportFont.Arial  ;
                        const AFontSize: Double = TReportFont.Size_8 ;
                        const AFontStyle: TFontStyles = [];
                        const AFontColor: TColor = clBlack);
    end;

    TBaseReportExt = class helper for TBaseReport
    private
      procedure DrawLine(const X1, Y1, X2, Y2: Double;
      	const PenSt:TPenStyle = psSolid;
        const Width:Integer = 1;
        const Doubl:Boolean = False);
      procedure SetTabBox(const Index:Integer; const BoxLine:Byte);
    public
      procedure AdjustPos(const NewX, NewY: Double; out X, Y: Double) ;
      procedure PrintText(const X, Y: Double;
      	const Text: string;
        const Just: TPrintJustify = pjLeft;
        const Width: Double = 0.00); overload;
      procedure PrintText(const X, Y: Double;
      	const Text: string;
        const fName: string = 'Arial';
        const fSize: Double = 8 ;
        const fStyles: TFontStyles = [];
        const fColor: TColor = clWindowText;
        const Just: TPrintJustify = pjLeft;
        const Width: Double = 0.00); overload;
      procedure PrintHeader(Stru: TReportHeader); overload;
      procedure PrintFooter(Stru: TReportFooter); overload;
      procedure PrintTab(	const Index:Integer;
                          const Text:string;
                          const Just:TPrintJustify;
                          const BoxLine:Byte;
                          const Shade:Byte = 0); overload;
      procedure HSimpleLine(const ANewLine:Boolean=False);
      procedure HDoubleLine;
      procedure VSimpleLine;
      procedure VDoubleLine;
      procedure NewLine(out X,Y: Double;
                        const Lines: Integer=1;
                        const NewX: Double=0); overload ;
      procedure RestoreTabs(const Index:Integer;
      											const Just:TTabJustify;
                          	const BoxLine:Byte;
                          	const Shade:Byte = 0); overload;
    end;

    TCustomRvSystem = class(TRvSystem)
    private
      FRpt :TBaseReport;
      FFormatFont: TFormatFont;
      FDeviceName :string ;
      FFileName:string;
      FOrientation:TOrientation;
      FPaperSize  :Byte;
      FPaperWidth :Double;
      FPaperHeight:Double;
    protected
      FRvRenderPDF: TRvRenderPDF;
      FRvRenderText: TRvRenderText;
      procedure DoInit(Sender: TObject); //virtual;
    public
      property PaperSize  :Byte     read FPaperSize     write FPaperSize      ;
      property PaperWidth :Double   read FPaperWidth    write FPaperWidth     ;
      property PaperHeight:Double   read FPaperHeight   write FPaperHeight    ;
      property Rpt :TBaseReport     read FRpt           write FRpt;
      property DeviceName: String read FDeviceName write FDeviceName ;

      constructor Create(AOrientation: TOrientation;
      	ADest: TReportDest=rdPreview;
        AFile: TFileName=''); reintroduce;
      destructor Destroy; override;

    public
      procedure DrawText(const X, Y: Double;
        const Text: string;
        const Justify: TPrintJustify = pjLeft;
        const fName: string = TReportFont.Arial  ;
        const fSize: Double = TReportFont.Size_8 ;
        const fStyle: TFontStyles = [];
        const fColor: TColor = clBlack;
        const Width: Double = 0.00);

      procedure DrawBox(const X1, Y1, X2, Y2: Double;
        const Caption: TFormatText  ;
        const Text: TFormatText  ) ;

      procedure SetFont(AFormatFont: TFormatFont);

      //
//      procedure PrintTabs
    end;


implementation

uses StrUtils, Math ,
  RpMemo  ;
//		ShellApi;


const
    FONT_ARIAL      = 'Arial';
    FONT_TIMES_NW   = 'Times New Roman';
    FONT_COURIER_NW = 'Courier New';
    FONT_SIZE_06 = 06;
    FONT_SIZE_07 = 07;
    FONT_SIZE_08 = 08;
    FONT_SIZE_10 = 10;
    FONT_SIZE_12 = 12;
    FONT_SIZE_14 = 14;

{$J+}
const
  ActiveFontName			:string='Arial';
  ActiveFontSize			:Double=8;
  ActiveFontBold			:Boolean=False;
  ActiveFontItalic		:Boolean=False;
  ActiveFontUnderline	:Boolean=False;
  ActiveFontColor			:TColor=clWindowText;
  ActiveJust					:TPrintJustify=pjLeft;
{$J-}


{ TBaseReportExt }

procedure TBaseReportExt.AdjustPos(const NewX, NewY: Double; out X, Y: Double);
begin
    Self.GotoXY(NewX, NewY);
    X :=Self.XPos ;
    Y :=Self.YPos ;
end;

procedure TBaseReportExt.DrawLine(const X1, Y1, X2, Y2: Double;
  const PenSt:TPenStyle;
  const Width:Integer;
  const Doubl:Boolean);
begin
  	Self.SetPen(clWindowText, PenSt, Width, pmCopy);
    Self.MoveTo(X1, Y1);
    Self.LineTo(X2, Y2);
    if Doubl then
    begin
        Self.MoveTo(X1, Y1 -0.05);
        Self.LineTo(X2, Y2 -0.05);
    end;
    Self.SetPen(clWindowText, psSolid, 1, pmCopy);
end;

procedure TBaseReportExt.HDoubleLine;
begin
  	Self.DrawLine(MarginLeft, MarginTop				, SectionRight, MarginTop				);
    Self.DrawLine(MarginLeft, MarginTop -0.05	, SectionRight, MarginTop -0.05	);
end;

procedure TBaseReportExt.HSimpleLine(const ANewLine:Boolean=False);
var x,y:Double;
begin
    if ANewLine then
    begin
      Self.NewLine;
    end;
    x :=Self.MarginLeft;
    y :=Self.YPos -(Self.FontHeight/2);
    Self.DrawLine(x, y, Self.SectionRight, y);
end;

procedure TBaseReportExt.NewLine( out X, Y: Double;
                                  const Lines: Integer=1;
                                  const NewX: Double=0);

var l: Integer  ;
begin
    if Lines>1 then
    begin
        for l :=1 to Lines do
        begin
            Self.NewLine;
        end;
    end
    else begin
        Self.NewLine;
    end;
    if NewX>0 then
    begin
        Self.XPos :=NewX  ;
    end;
    X :=Self.XPos;
    Y	:=Self.YPos;
end;

procedure TBaseReportExt.PrintFooter(Stru: TReportFooter);
var
    bkp_color: TColor	;
begin
    GotoXY(MarginLeft, SectionBottom);
    HSimpleLine();
    bkp_color :=FontColor	;
    try
        Bold:=False;
        FontColor:=clBlack	;
        PrintText(MarginLeft	, YPos +0.10, Stru.unit_nome, pjLeft);
        PrintText(SectionRight, YPos +0.10, Stru.user_desc, pjRight);
    finally
        FontColor :=bkp_color	;
    end;
end;

procedure TBaseReportExt.PrintHeader(Stru: TReportHeader);
var X,Y:Double;
var P,H:Double;
var R:TRect;
var S:string;
begin
    //
    case Self.Orientation of
      poPortrait	:P	:=16.75;
      poLandScape :P	:=25.25;
    else
    	P	:=16.75;
    end;

    X :=Self.MarginLeft;
    Y :=Self.MarginTop;

//    if (Trim(Stru.font_name)<>'') and (Stru.font_size>0) then
//    begin
//    	Self.SetFont(Stru.font_name, Stru.font_size);
//    end
//    else begin
//    	Self.SetFont('Courier New', 10);
//    end;
//    Self.AdjustLine;

    Self.SetFont('Arial', 9);
    Self.AdjustLine;

    Self.Italic :=True	;
    Self.PrintText(SectionRight/2, Y, '* SUPORTWARE INFORMATICA *', pjCenter);
    Self.Italic :=False	;

    Y :=Y +0.05;

    Self.Rectangle(X				, Y, X +2.54						, Y +1.50);
    Self.Rectangle(X +2.54	, Y, Self.SectionRight	, Y +1.50);
    if Assigned(Stru.empresa_logo) then
    begin
        R :=Self.CreateRect(X +0.05, Y +0.05, X +2.50, Y +1.45);
        Self.StretchDraw(R, Stru.empresa_logo);
    end;
    //

    H :=Self.LineHeight;
    Self.PrintText(X +2.64, Y +H, Stru.empresa_nome, pjLeft);

    X :=(SectionRight/2) +2.54; //1.27
    Self.Bold	:=True;
    Self.PrintText(X, Y +H, Stru.titulo_linha01, pjCenter);
    Self.Bold	:=False;

    S :='Pag : '+ Self.Macro(midCurrentPage) +' de '+ Self.Macro(midTotalPages);
    P :=Self.SectionRight -Self.TextWidth('Data: 00/00/0000');
    Self.PrintText(P, Y +H, S, pjLeft);
    //
    Self.PrintText(X, Y +2*H, Stru.titulo_linha02, pjCenter);
    S :=FormatDateTime('"Data: "dd/mm/yyyy', Now);
    Self.PrintText(P, Y +2*H, S, pjLeft);
    //
    Self.PrintText(Self.MarginLeft +2.64, Y +3*H, 'SWR-GESTOR', pjLeft);
    //
    Self.PrintText(X, Y +3*H, Stru.titulo_linha03, pjCenter);
    S :=FormatDateTime('"Hora: "hh:nn:ss', Now);
    Self.PrintText(P, Y +3*H, S, pjLeft);
    //
    X :=Self.MarginLeft;
    Y :=Y +1.50;
    Self.GotoXY(X,Y);
    //
end;

procedure TBaseReportExt.PrintTab(const Index: Integer;
	const Text: string;
  const Just:TPrintJustify;
  const BoxLine, Shade: Byte);
var tab:TTab;
begin
    tab 				:=Self.GetTab(Index);
    tab.Justify	:=Just;
    tab.Shade		:=Shade;
    SetTabBox(Index, BoxLine);
    Self.PrintTab(Text);
end;

procedure TBaseReportExt.PrintText(const X, Y: Double;
	const Text: string;
  const Just: TPrintJustify;
  const Width: Double);
var txt: string;
begin
    Self.GotoXY(X, Y);
    if Width > 0 then
      txt :=Self.TruncateText(Text, Width)
    else
      txt	:=Text;
    case Just of
        pjLeft    : Self.PrintLeft  (txt, X);
        pjCenter  : Self.PrintCenter(txt, X);
        pjRight   : Self.PrintRight (txt, X);
        pjBlock   : Self.PrintBlock (txt, X, Width);
    else
      	Self.PrintLeft(txt, X);
    end;
end;

procedure TBaseReportExt.PrintText(const X, Y: Double;
	const Text, fName: string;
  const fSize: Double;
  const fStyles: TFontStyles;
  const fColor: TColor;
  const Just: TPrintJustify;
  const Width: Double);
begin
    if (fName <> ActiveFontName) or (fSize <> ActiveFontSize) then
    begin
      	ActiveFontName	:=fName;
      	ActiveFontSize	:=fSize;
        Self.SetFont(ActiveFontName, ActiveFontSize);
    end;
    if fColor <> ActiveFontColor then
    begin
      	ActiveFontColor :=fColor;
        FontColor :=ActiveFontColor;
    end;
    Self.Bold      :=fsBold 			in fStyles;
    Self.Italic    :=fsItalic 		in fStyles;
    Self.Underline :=fsUnderline	in fStyles;
    Self.AdjustLine;
    Self.PrintText(X, Y, Text, Just, Width);
end;

procedure TBaseReportExt.RestoreTabs(const Index: Integer;
  const Just: TTabJustify;
  const BoxLine, Shade: Byte);
begin
  	Self.RestoreTabs(Index);
    Self.TabJustify	:=Just;
end;

procedure TBaseReportExt.SetTabBox(const Index: Integer; const BoxLine: Byte);
var
		tab: TTab;
begin
    tab	:=Self.GetTab(Index);
    if tab<>nil then
    begin
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
    end;
end;

procedure TBaseReportExt.VDoubleLine;
begin

end;

procedure TBaseReportExt.VSimpleLine;
begin

end;

{ TCustomRvSystem }

constructor TCustomRvSystem.Create(	AOrientation: TOrientation;
                                    ADest: TReportDest=rdPreview;
                                    AFile: TFileName='');
begin
  inherited Create(nil);

  //RpDevice.RPDev.Printers

  //
  FOrientation							:=AOrientation;
  SystemSetups 							:=SystemSetups - [ssAllowSetup];
  SystemPreview.RulerType   :=rtBothCm;
  SystemPrinter.Units       :=unCM;
  SystemPrinter.UnitsFactor :=2.54;
  SystemPrinter.Orientation :=FOrientation;

  case ADest of
      rdPreview:DefaultDest:=rdPreview;
      rdPrinter:
      begin
          DefaultDest :=rdPrinter;
      end;
      rdFile:
      begin
        fRvRenderPDF  :=TRvRenderPDF.Create(Self);
        fRvRenderPDF.BufferDocument  :=True;
        fRvRenderPDF.DocInfo.Creator :='suportware.com.br';
        fRvRenderPDF.DocInfo.Producer:='suportware informatica';
        fRvRenderPDF.EmbedFonts      :=True;
        fRvRenderPDF.ImageQuality		 :=90;
        fRvRenderPDF.MetafileDPI		 :=300;

        FRvRenderText:=TRvRenderText.Create(nil);

      	DefaultDest 		:=rdFile;
        DoNativeOutput  :=False;
        RenderObject    :=fRvRenderPDF;
        OutputFileName  :=Format('%s', [AFile]);
      end;
  end;

  Self.PaperSize    :=DMPAPER_A4;
  Self.PaperWidth		:=0.00;
  Self.PaperHeight	:=0.00;

  OnBeforePrint :=DoInit;

end;

destructor TCustomRvSystem.Destroy;
begin
  if Assigned(fRvRenderPDF) then fRvRenderPDF.Destroy;
  if Assigned(FRvRenderText)then fRvRenderText.Destroy;
  inherited Destroy;
end;

procedure TCustomRvSystem.DoInit(Sender: TObject);
begin
    FRpt :=(Sender as TBaseReport) ;

    if DefaultDest = rdPrinter then
    begin
        if FDeviceName<>'' then
        begin
            if not Rpt.SelectPrinter(FDeviceName) then
            begin
                Rpt.Abort ;
                raise Exception.CreateFmt('Impressora [%s] não localizada!',[FDeviceName]);
            end;
        end
        else
        begin
//            if not Rpt.ShowPrinterSetupDialog then
//            begin
//                raise Exception.Create('Impressora não selecionada!');
//            end;
        end;
    end;
    Rpt.Orientation	:= FOrientation;
    Rpt.SetPaperSize(FPaperSize, FPaperWidth, FPaperHeight);
    Rpt.MarginTop    :=1.00;
    Rpt.MarginBottom :=1.00;
    Rpt.MarginLeft   :=1.00;
    Rpt.MarginRight  :=1.00;
    FFormatFont.Name  :=Rpt.FontName ;
    FFormatFont.Size  :=Rpt.FontSize ;
    FFormatFont.Color :=Rpt.FontColor ;
    FFormatFont.Style :=[];
end;

procedure TCustomRvSystem.DrawBox(const X1, Y1, X2, Y2: Double;
  const Caption: TFormatText  ;
  const Text: TFormatText  ) ;
var
    m:TMemoBuf;
var
    x,y,p:Double;

begin
    Rpt.Rectangle(X1, Y1, X2, Y2);
    if Caption.Text<>'' then with Caption do
    begin
        //
        try
            Rpt.SetFont(Font.Name,Font.Size);
            Rpt.AdjustLine;
            y :=Y1 +Rpt.FontHeight +0.07 ;
        finally
            Rpt.SetFont(FFormatFont.Name, FFormatFont.Size);
            Rpt.AdjustLine;
        end;
        //
        case Justify of
            pjLeft:
            begin
                x :=X1 +0.10 ;
                DrawText( x, y,
                          Text,
                          pjLeft,
                          Font.Name,
                          Font.Size,
                          Font.Style,
                          Font.Color);
            end;

            pjCenter:
            begin
                x :=X1+(X2-X1)/2 ;
                DrawText( x, y ,
                          Text,
                          pjCenter,
                          Font.Name,
                          Font.Size,
                          Font.Style,
                          Font.Color);
            end;

            pjRight:
            begin
                x :=x2 -0.10 ;
                DrawText( x, y ,
                          Text,
                          pjRight,
                          Font.Name,
                          Font.Size,
                          Font.Style,
                          Font.Color);
            end;
        end;
    end;

    if Text.Text<>'' then with Text do
    begin
        if Rpt.TextWidth(Text) > (X2-X1) then
        begin
            m             :=TMemoBuf.Create;
            m.BaseReport  :=BaseReport;
            m.Text        :=Text;
            m.PrintStart  :=X1 +0.10;
            m.PrintEnd    :=X2 -0.10;
            m.PrintLines(0,False);
            m.Free;
        end
        else
        begin
            case Justify of
                pjLeft:
                begin
                    x :=X1 +0.10  ;
                    y :=Y2 -0.10  ;
                    DrawText( x, y,
                              Text,
                              pjLeft,
                              Font.Name,
                              Font.Size,
                              Font.Style,
                              Font.Color);
                end;

                pjCenter:
                begin
                    x :=X1 +(X2 - X1)/2 ;
                    y :=Y2 -0.10  ;
                    DrawText( x, y,
                              Text,
                              pjCenter,
                              Font.Name,
                              Font.Size,
                              Font.Style,
                              Font.Color);
                end;

                pjRight:
                begin
                    x :=X2 -0.10 ;
                    y :=Y2 -0.10  ;
                    DrawText( x, y,
                              Text,
                              pjRight,
                              Font.Name,
                              Font.Size,
                              Font.Style,
                              Font.Color);
                end;
            end;
        end;
    end;
end;

procedure TCustomRvSystem.DrawText(const X, Y: Double;
    const Text: string;
    const Justify: TPrintJustify;
    const fName: string;
    const fSize: Double;
    const fStyle: TFontStyles;
    const fColor: TColor;
    const Width: Double);
var posX, posY: Double ;
var S: string ;
var P: Integer ;
begin
    S :=Text ;
    P :=PosEx(#13#10, S)  ;
    if P>0 then
    begin
        S :=Copy(S, P+2, Length(S)) ;
        Rpt.NewLine(posX, posY);
        if X<>NA then
        begin
            posX :=X  ;
        end;
    end
    else
    begin
        posX :=X  ;
        posY :=Y  ;
        Rpt.GotoXY(posX, posY);
    end;

    try
//        if (fName<>FFormatFont.Name)or(fSize<>FFormatFont.Size) then
//        begin
            BaseReport.SetFont(fName, fSize);
            BaseReport.AdjustLine;
//        end;
        BaseReport.FontColor :=fColor ;
        BaseReport.Bold  :=fsBold in fStyle;
        BaseReport.Italic:=fsItalic in fStyle;
        BaseReport.Underline :=fsUnderline in fStyle;

        case Justify of
            pjLeft    : BaseReport.PrintLeft   (S, posX);
            pjCenter  : BaseReport.PrintCenter (S, posX);
            pjRight   : BaseReport.PrintRight  (S, posX);
            pjBlock   : BaseReport.PrintBlock  (S, posX, Width);
        end;
    finally
//        if (fName<>FFormatFont.Name)or(fSize<>FFormatFont.Size) then
//        begin
            BaseReport.SetFont(FFormatFont.Name, FFormatFont.Size);
            BaseReport.AdjustLine;
//        end;
        BaseReport.FontColor :=FFormatFont.Color ;
        BaseReport.Bold  :=fsBold in FFormatFont.Style ;
        BaseReport.Italic:=fsItalic in FFormatFont.Style ;
        BaseReport.Underline :=fsUnderline in FFormatFont.Style ;
    end;
end;

procedure TCustomRvSystem.SetFont(AFormatFont: TFormatFont);
begin
    FFormatFont.Assign(AFormatFont);
    BaseReport.SetFont(AFormatFont.Name, FFormatFont.Size);
    BaseReport.AdjustLine ;
    BaseReport.FontColor :=FFormatFont.Color ;
    BaseReport.Bold :=fsBold in FFormatFont.Style ;
    BaseReport.Italic:=fsItalic in FFormatFont.Style ;
    BaseReport.Underline :=fsUnderline in FFormatFont.Style ;
end;

{ TFormatText }

procedure TFormatText.SetText(const AText: string;
                              const AJust: TPrintJustify;
                              const AFontName: TFontName;
                              const AFontSize: Double;
                              const AFontStyle: TFontStyles;
                              const AFontColor: TColor);
begin
    Text      :=AText  ;
    Justify   :=AJust ;
    Font.Name :=AFontName ;
    Font.Size :=AFontSize ;
    Font.Style:=AFontStyle;
    Font.Color:=AFontColor;
end;

{ TFormatFont }

procedure TFormatFont.Assign(AFormatFont: TFormatFont);
begin
    Self.Color :=AFormatFont.Color ;
    Self.Name  :=AFormatFont.Name  ;
    Self.Size  :=AFormatFont.Size  ;
    Self.Style :=AFormatFont.Style ;
end;



{*******************************************************************************
*}


{ TRvCustomCodBase }

constructor TRvCustomCodBase.Create(const AOrientation: TRvOrientation;
  const APaperSize: Byte;
  const APaperWidth, APaperHeight: Double;
  const AUnits: TPrintUnits;
  const AUnitsFactor: Double);
begin
  inherited Create(nil);

  SystemOptions :=SystemOptions +[soUseFiler];
  SystemFiler.StatusFormat :='Gerando pagina %d ...';
  SystemSetups :=SystemSetups - [ssAllowSetup];

  Report :=nil;
  Orientation :=AOrientation ;
  PaperSize :=APaperSize;
  PaperHeight :=APaperHeight;
  PaperWidth :=APaperWidth;
  Units :=AUnits ;
  UnitsFactor :=AUnitsFactor;

  FCopies :=1;
  FMarginTop :=1.00 ;
  FMarginBottom :=1.00 ;
  FMarginLeft :=1.00 ;
  FMarginRight :=1.00 ;

  Self.OnBeforePrint :=DoInit;
  Self.OnPrint :=DoPrint;

  Box :=TRvBox.Create;

end;

destructor TRvCustomCodBase.Destroy;
begin
  Box.Destroy;
  if Assigned(RenderPDF) then RenderPDF.Destroy ;
  inherited Destroy;
end;

procedure TRvCustomCodBase.DoDecodeImage(Sender: TObject; ImageStream: TStream;
  ImageType: String; Bitmap: Graphics.TBitmap);
var Image: TJPEGImage;
begin
  if ImageType = 'JPG' then
  begin
    Image := TJPEGImage.Create; // Create a TJPEGImage class
    try
      Image.LoadFromStream(ImageStream); // Load up JPEG image from ImageStream
      Image.DIBNeeded; // Convert JPEG to bitmap format
      Bitmap.Assign(Image);
    finally
      Image.Free;
    end;
  end;
end;

procedure TRvCustomCodBase.DoExecute(const Dest: TRvDestination;
  const RenderOutput: TRvRenderOutput);
var
  RenderObj: TRPRender; //TRPRenderStream; //TRvRenderPDF;
begin
  Self.DefaultDest :=Dest;

  RenderObj :=nil;
  case RenderOutput  of
    roText:
    begin
      RenderObj :=TRvRenderText.Create(Self);
      //TRvRenderText(RenderObj).
    end;

    roPDF:
    begin
      RenderObj :=TRvRenderPDF.Create(Self);
      TRvRenderPDF(RenderObj).EmbedFonts  :=True;
      TRvRenderPDF(RenderObj).ImageQuality:=90;
      TRvRenderPDF(RenderObj).MetafileDPI:=300;
      TRvRenderPDF(RenderObj).UseCompression:=False;
      TRvRenderPDF(RenderObj).DocInfo.Creator :='suportware.com.br';
      TRvRenderPDF(RenderObj).DocInfo.Producer:='Suportware Informatica Ltda';
    end;

    roHTML:
    begin
    end;
  end;

  if RenderOutput <> roNone then
  begin
    Self.DefaultDest  :=rdFile;
    Self.RenderObject :=RenderObj;
    Self.DoNativeOutput:=False;
  end;

  case Self.DefaultDest of
    rdPreview:
    begin
      SystemPreview.RulerType :=rtBothCm;
      SystemPreview.FormWidth :=Report.XU2D(PaperWidth) ;
      SystemPreview.FormHeight:=Report.YU2D(PaperHeight);
    end;
    rdPrinter:
    begin
      SystemPrinter.Orientation :=Report.Orientation;
      SystemPrinter.Units :=Units ;
      SystemPrinter.UnitsFactor :=UnitsFactor ;
      SystemPrinter.MarginTop :=FMarginTop;
      SystemPrinter.MarginBottom :=FMarginBottom;
      SystemPrinter.MarginLeft :=FMarginLeft;
      SystemPrinter.MarginRight :=FMarginRight;
      SystemPrinter.StatusFormat:='Imprimindo pagina %d ...';
      SystemPrinter.Title :=Self.TitlePreview ;
      SystemPrinter.Copies :=FCopies;
    end;
  end;

  Self.Execute();

  if Assigned(RenderObj) then
  begin
    FreeAndNil(RenderObj);
  end;

end;

procedure TRvCustomCodBase.DoInit(Sender: TObject);
begin

  Report :=Self.BaseReport;
  Report.Orientation :=Orientation;
  Report.Units :=Units;
  Report.UnitsFactor :=UnitsFactor;
  Report.MarginTop    :=FMarginTop;
  Report.MarginBottom :=FMarginBottom;
  Report.MarginLeft   :=FMarginLeft;
  Report.MarginRight  :=FMarginRight;
  Report.ResetSection ;

  Report.Title :=FTitlePreview;

  if FPrinterName <> '' then
  begin
    Report.SelectPrinter(FPrinterName);
    Report.Copies :=FCopies ;
  end;

  if PaperSize > 0 then
    Report.SetPaperSize(PaperSize, 0, 0)
  else
    Report.SetPaperSize(PaperSize, PaperWidth, PaperHeight);

end;

procedure TRvCustomCodBase.DrawBox(const NewX, NewY, NewWidth, NewHeight: Double;
  const NewMargin: Double;
  const NewShade: Byte ;
  const NewJustify: TPrintJustify;
  const NewStyles: TFontStyles);
var
  ShadePercent: Byte;
  SavePen: TPen;
  SaveBrush: TBrush;
  NewBrush: TBrush;
  NewPen: TPen;
  BkMode: Integer;
begin
  if not Assigned(Report) then Exit;

  if NewX < 0 then
  begin
    if Box.Left > 0 then
      Box.Left :=Box.Left +Box.Width
    else
      Box.Left :=Report.MarginLeft;
  end
  else begin
    Box.Left :=NewX;
  end;

  if NewWidth > 0 then
  begin
    if Box.Left +NewWidth > Report.SectionRight then
      Box.Width :=(Report.SectionRight -Box.Left)
    else
      Box.Width :=NewWidth;
  end;

  if NewY < 0 then
  begin
    if Box.Top > 0 then
      Box.Top :=Box.Top +Box.Height
    else
      Box.Top :=Report.MarginTop;
  end
  else begin
    Box.Top :=NewY;
  end;

  if NewHeight > 0 then
  begin
    if Box.Top +NewHeight > Report.SectionBottom then
      Box.Height :=(Report.SectionBottom -Box.Top)
    else
      Box.Height :=NewHeight;
  end;

  Box.Margin :=NewMargin;
  Box.Shade :=NewShade;
  Box.Justify :=NewJustify;
  Box.Styles  :=NewStyles;

  //desenha o Box
  if(Box.Width > 0)and(Box.Height > 0) then
  begin

    //See if we need to shade the box
    //ShadePercent := 0;
    ShadePercent := Report.TabShade;
    if Box.Shade > 0 then
    begin
      ShadePercent :=Box.Shade;
    end;// else if Report.TabShade > 0 then
//    begin
//      ShadePercent := Report.TabShade;
//    end; { else }

    if ShadePercent > 0 then
    begin
      //Save off current brush and pen
      SaveBrush := TBrush.Create;
      SaveBrush.Assign(Report.Canvas.Brush);
      SavePen := TPen.Create;
      SavePen.Assign(Report.Canvas.Pen);

      //Create new brush and pen
      NewBrush := TBrush.Create;
      NewBrush.Color := ShadeToColor(Report.TabColor, ShadePercent);
      NewBrush.Style := bsSolid;
      NewPen := Report.CreatePen(Report.BoxLineColor, psClear, 1, pmMask);

      //Assign new brush and pen
      Report.Canvas.Brush.Assign(NewBrush);
      NewBrush.Free;
      Report.Canvas.Pen.Assign(NewPen);
      NewPen.Free;

      //Draw rectangle
      BkMode := GetBkMode(Report.Canvas.Handle);
      SetBkMode(Report.Canvas.Handle, TRANSPARENT);

      Report.Rectangle(Box.Left, Box.Top, Box.Right, Box.Bottom);
      SetBkMode(Report.Canvas.Handle,BkMode);

      //Reset Brush and Pen
      Report.Canvas.Brush.Assign(SaveBrush);
      SaveBrush.Free;
      Report.Canvas.Pen.Assign(SavePen);
      SavePen.Free;
    end; { if }

    Report.Rectangle(Box.Left, Box.Top, Box.Right, Box.Bottom);
    //Report.TabRectangle(Box.Left, Box.Top, Box.Right, Box.Bottom);

  end; { if }

end;

procedure TRvCustomCodBase.DrawLine(const X1, Y1, X2, Y2: Double;
  const Style: TPenStyle);
var
  SavePen: TPen;
  NewPen: TPen;
begin
  if Assigned(Report) then
  begin
    SavePen :=TPen.Create;
    NewPen  :=Report.CreatePen(clBlack, Style, 1, pmCopy);
    try
      SavePen.Assign(Report.Canvas.Pen);
      Report.Canvas.Pen.Assign(NewPen);

      //Draw line
      Report.MoveTo(X1, Y1);
      Report.LineTo(X2, Y2);

    finally
      NewPen.Free;
      Report.Canvas.Pen.Assign(SavePen);
      SavePen.Free;
    end;
  end;
end;

procedure TRvCustomCodBase.DrawLineHorz(const PosY: Double; const Style: TPenStyle);
begin
  Report.GotoXY(0, PosY);
  Self.DrawLine(0, Report.YPos, Report.PageWidth, Report.YPos, Style);
end;

procedure TRvCustomCodBase.DrawLineVert(const PosX: Double; const Style: TPenStyle);
begin
  Report.GotoXY(PosX, 0);
  Self.DrawLine(Report.XPos, 0, Report.XPos, Report.PageHeight, Style);
end;

function TRvCustomCodBase.FormatNumPage(const AFormat: string): string;
begin
  if Assigned(Report) then
  begin
    Result :=Format(AFormat, [Report.CurrentPage, Report.JobPages]);
  end;
end;

procedure TRvCustomCodBase.NewLines(const Lines: Integer;
  const FontName: string; FontSize: Double);
var
  I: Integer;
begin
  if Assigned(Report) then
  begin
    if(FontName <> '')and(FontSize > 0)then
    begin
      Report.SetFont(FontName, FontSize);
      Report.AdjustLine ;
    end;
    for I :=1 to Lines do
    begin
      Report.NewLine();
    end;
  end;
end;

procedure TRvCustomCodBase.PrintBarCod128(const CodBar: string;
  const X, Y: Double;
  const BarH, BarW: Double);
var
  cod128: TRPBarsCode128;
begin
  if Assigned(Report) then
  begin
    cod128  :=TRPBarsCode128.Create(Report);
    try
      cod128.CodePage  :=cpCodeC;
      cod128.Text      :=CodBar;
      cod128.BarHeight :=BarH;
      cod128.BarWidth  :=BarW;
      cod128.PrintReadable:=False;
      cod128.PrintXY(X, Y);
    finally
      cod128.Free;
    end;
  end;
end;

procedure TRvCustomCodBase.PrintBox(const X, Y: Double;
  const Text: string;
  const Style: TFontStyles;
  const LinesPerInch: Integer);
var
  newX,newY: Double;
  M: TMemoBuf;
  oldLineHeightMethod: TLineHeightMethod;
  oldLinesPerInch: Integer;
  Lines: Integer;
begin
  if not Assigned(Report) then
  begin
    Exit;
  end;

  if X < 0 then
  begin
    if Report.FontRotation = 0 then
      newX :=Report.XPos
    else
      newX :=Report.XPos +Report.LineHeight;
  end
  else if X = 0 then
  begin
    if Report.FontRotation = 0 then
      newX :=Box.Left +Box.Margin
    else
      newX :=Box.Left +Box.Margin +Report.FontHeight;
  end
  else if X > 0 then
  begin
    newX :=Box.Left +X;
  end;

  if Y < 0 then
  begin
    newY :=Report.YPos +Report.LineHeight;
  end
  else if Y = 0 then
  begin
    newY :=Box.Top +Report.FontHeight;
  end
  else if Y > 0 then
  begin
    newY :=Box.Top +Y;
  end;
  Report.GotoXY(newX, newY);

  if fsBold       in Style then Report.Bold       :=True;
  if fsItalic     in Style then Report.Italic     :=True;
  if fsUnderline  in Style then Report.Underline  :=True;
  if fsStrikeOut  in Style then Report.Strikeout  :=True;

  //if(Report.TextWidth(Text)+X > (Box.Width -2*Box.Margin))or(Pos(#13, Text) > 0) then
  if(Report.TextWidth(Text) > (Box.Width -2*Box.Margin))or(Pos(#13, Text) > 0) then
  begin
    oldLineHeightMethod :=Report.LineHeightMethod;
    oldLinesPerInch     :=Report.LinesPerInch;
    Report.LineHeightMethod :=lhmLinesPerInch;
    Report.LinesPerInch :=LinesPerInch;
    M :=TMemoBuf.Create;
    try
      M.BaseReport  :=Self.Report;
      M.Text        :=Text;
      M.Justify     :=Box.Justify;
//      if Report.FontRotation = 0 then
//      begin
        M.PrintStart  :=Box.Left  +Box.Margin +X;
        M.PrintEnd    :=Box.Right -Box.Margin;
//      end
      M.PrintLines(M.MemoLinesLeft, False);
    finally
      M.Free;
      Report.LineHeightMethod :=oldLineHeightMethod;
      Report.LinesPerInch :=oldLinesPerInch;
    end;
  end
  else begin

    case Box.Justify of
      pjLeft:
      begin
        //NewX :=Box.Left +Box.Margin +X;
        Report.PrintLeft(Text, NewX);
      end;
      pjCenter:
      begin
        NewX :=Box.Left +Box.Width/2;
        Report.PrintCenter(Text, NewX);
      end;
      pjRight:
      begin
        NewX :=(Box.Right -Box.Margin) -X;
        Report.PrintRight(Text, NewX);
      end
    else
      NewX :=Box.Left +Box.Margin +X;
    end;
//      Report.PrintJustify(Text, Report.XU2I(NewX), Box.Justify, 0, Box.Width);
  end;

  if fsBold       in Style then Report.Bold       :=False;
  if fsItalic     in Style then Report.Italic     :=False;
  if fsUnderline  in Style then Report.Underline  :=False;
  if fsStrikeOut  in Style then Report.Strikeout  :=False;

end;

{***
* O argumento <Text> alem de conter o texto de impressão tbm fornece os
* comandos de formatação da seguinte forma: #Align;Styles;Color
*   Align = (L,C,R,B);
*   Styles =[B,I,S];
*   Color = uma string contendo as cores validas (clBlack, $00CAB2A9, ...)
* OBS - Se nenhum comando for informado será assumido o padrão definido nas
*       configurações do BOX
*}
procedure TRvCustomCodBase.PrintBox(const Text: string;
  const X, Y: Double;
  const LinesPerInch: Integer);
  //
  function getCmd(var S: string): String;
  var
    P: Integer;
  begin
    case Length(S) of
      0: Result :=#0;
      1:
      begin
        Result :=S[1];
        S :='';
      end;
    else
      P :=Pos(';', S);
      if P > 0 then
      begin
        Result :=Copy(S, 1, P-1);
        S :=Copy(S, P+1, Length(S));
      end
      else begin
        Result :=S;
        S :='';
      end;
    end;
  end;
  //

var
  newX,newY: Double;
var
  M: TMemoBuf;
  oldLineHeightMethod: TLineHeightMethod;
  oldLinesPerInch: Integer;
var
  Txt,S,C: string ;
  Just: TPrintJustify;
  Styles: TFontStyles;
  P: Integer;
begin
  if not Assigned(Report) then
  begin
    Exit;
  end;

  Txt :=Text;
  Just:=Box.Justify;
  Styles :=Box.Styles;

  //comandos
  P :=Pos('#', Text);
  if P > 0 then
  begin
    Txt :=Copy(Text, 1, P-1);
    S   :=Copy(Text, P+1, Length(Text));

    //justificado
    C :=getCmd(S) ;
    case C[1] of
      'C': Just :=pjCenter;
      'L': Just :=pjLeft ;
      'R': Just :=pjRight;
      'B': Just :=pjBlock;
    end;

    //estilos
    C :=getCmd(S);
    if C[1] = '[' then
    begin
      if Pos('B', C) > 0 then Styles :=[fsBold];
      if Pos('I', C) > 0 then Styles :=Styles +[fsItalic];
      if Pos('U', C) > 0 then Styles :=Styles +[fsUnderline];
      if Pos('S', C) > 0 then Styles :=Styles +[fsStrikeOut];
    end;

    //color
    C :=getCmd(S);
    if C[1] in['$','c'] then
    begin
        //StringToColor()
    end;

  end ;

  if fsBold       in Styles then Report.Bold     :=True;
  if fsItalic     in Styles then Report.Italic   :=True;
  if fsUnderline  in Styles then Report.Underline:=True;
  if fsStrikeOut  in Styles then Report.Strikeout:=True;

  if X < 0 then
  begin
    newX :=Report.XPos +Math.IfThen(Report.FontRotation > 0, Report.LineHeight);
  end

  else if X = 0 then
  begin
    newX :=Box.Left +Box.Margin +Math.IfThen(Report.FontRotation > 0, Report.FontHeight) ;
  end

  else if X > 0 then
  begin
    newX :=Box.Left +X;
  end;

  if Y < 0 then
  begin
    newY :=Report.YPos +Report.LineHeight;
  end

  else if Y = 0 then
  begin
    newY :=Box.Top +Report.FontHeight;
  end
  else if Y > 0 then
  begin
    newY :=Box.Top +Y;
  end;

  Report.GotoXY(newX, newY);

  //if(Report.TextWidth(Text)+X > (Box.Width -2*Box.Margin))or(Pos(#13, Text) > 0) then
  if(Report.TextWidth(Txt) > (Box.Width -2*Box.Margin))or(Pos(#13, Txt) > 0) then
  begin
    oldLineHeightMethod :=Report.LineHeightMethod;
    oldLinesPerInch     :=Report.LinesPerInch;
    Report.LineHeightMethod :=lhmLinesPerInch;
    Report.LinesPerInch :=LinesPerInch;
    M :=TMemoBuf.Create;
    try
      M.BaseReport  :=Self.Report;
      M.Text        :=Txt;
      M.Justify     :=Just;
//      if Report.FontRotation = 0 then
//      begin
        M.PrintStart  :=Box.Left  +Box.Margin +X;
        M.PrintEnd    :=Box.Right -Box.Margin;
//      end
      M.PrintLines(0, False);
    finally
      M.Free;
      Report.LineHeightMethod :=oldLineHeightMethod;
      Report.LinesPerInch :=oldLinesPerInch;
    end;
  end
  else begin

    case Just of
      pjLeft:
      begin
        //NewX :=Box.Left +Box.Margin +X;
        Report.PrintLeft(Txt, NewX);
      end;
      pjCenter:
      begin
        NewX :=Box.Left +Box.Width/2;
        Report.PrintCenter(Txt, NewX);
      end;
      pjRight:
      begin
        if X > 0 then
          NewX :=Box.Right -X
        else
          NewX :=Box.Right -Box.Margin;
        Report.PrintRight(Txt, NewX);
      end
    else
      NewX :=Box.Left +Box.Margin +X;
    end;
//    Report.PrintJustify(Text, Report.XU2I(NewX), Box.Justify, 0, Box.Width);
  end;

  if fsBold       in Styles then Report.Bold     :=False;
  if fsItalic     in Styles then Report.Italic   :=False;
  if fsUnderline  in Styles then Report.Underline:=False;
  if fsStrikeOut  in Styles then Report.Strikeout:=False;

end;

procedure TRvCustomCodBase.PrintTab(const Index: Integer; const Text: string;
  const BoxLine: Byte);
var tab:TTab;
begin
  if not Assigned(Report) then
  begin
    Exit;
  end;

  tab :=Report.GetTab(Index);

  if tab = nil then
  begin
    Exit ;
  end;

  case BoxLine of
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
  Report.PrintTab(Text);
end;

procedure TRvCustomCodBase.PrintXY(const X, Y: Double;
  const Text: string;
  const Justify: TPrintJustify;
  const Styles: TFontStyles;
  const Color: TColor;
  const Width: Double);
var
  oldFontColor: TColor ;
begin
  if not Assigned(Report) then
  begin
    Exit;
  end;

  if fsBold       in Styles then Report.Bold       :=True;
  if fsItalic     in Styles then Report.Italic     :=True;
  if fsUnderline  in Styles then Report.Underline  :=True;
  if fsStrikeOut  in Styles then Report.Strikeout  :=True;
  if Color <> clNone then
  begin
    oldFontColor :=Report.FontColor;
    Report.FontColor :=Color;
  end;
  try
    Report.YPos :=Y;
    Report.PrintJustify(Text, Report.XU2I(X), Justify, 0, Width);
  finally
    if fsBold       in Styles then Report.Bold       :=False;
    if fsItalic     in Styles then Report.Italic     :=False;
    if fsUnderline  in Styles then Report.Underline  :=False;
    if fsStrikeOut  in Styles then Report.Strikeout  :=False;
    if Color <> clNone then Report.FontColor :=oldFontColor;
  end;
end;

procedure TRvCustomCodBase.SetFont(const NewName: String);
begin
  Self.SetFont(NewName, Report.FontSize);
end;

procedure TRvCustomCodBase.SetFont(const NewSize: Double);
begin
  Self.SetFont(Report.FontName, NewSize);
end;

procedure TRvCustomCodBase.SetFont(const NewName: String; const NewSize: Double);
var
  fname: string ;
  fsize: Double ;
begin
  if Assigned(Report) then
  begin
    //valida o nome da font
    if NewName <> '' then
    begin
      if Report.Fonts.IndexOf(NewName) >= 0 then
        fname :=NewName
      else
        fname :=Report.FontName;
    end
    else
      fname :=Report.FontName;

    if NewSize > 0 then
      fsize :=NewSize
    else
      fsize :=Report.FontSize ;

    Report.SetFont(fname, fsize);
    Report.AdjustLine;
  end;
end;

{ TRvCodBasePortrait }

constructor TRvCodBasePortrait.Create;
begin
  inherited Create(poPortrait);

end;

destructor TRvCodBasePortrait.Destroy;
begin

  inherited;
end;

{ TRvCodBaseLandScape }

constructor TRvCodBaseLandScape.Create;
begin
  inherited Create(poLandScape);

end;

destructor TRvCodBaseLandScape.Destroy;
begin

  inherited;
end;

{ TRvBox }

function TRvBox.Bottom: Double;
begin
  Result :=Self.Top + Self.Height;
end;

constructor TRvBox.Create;
begin
  Self.Justify :=pjLeft;
  Self.Styles :=[] ;
  Self.Color :=clBlack ;
end;

function TRvBox.Right: Double;
begin
  Result :=Self.Left + Self.Width;
end;


procedure TRvBox.SetBox(const AMargin: Double);
begin
  Self.Margin :=AMargin ;
end;

procedure TRvBox.SetBox(const AJust: TPrintJustify);
begin
  Self.Justify :=AJust ;
end;

procedure TRvBox.SetBox(const AShade: Byte);
begin
  Self.Shade :=AShade ;
end;


begin
//  RpDefine.DataID :=''

end.
