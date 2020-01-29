unit uefd_util;

interface

uses Windows,
	Messages,
  SysUtils,
  Classes ;


type  Tefd_util = class
      private
        const SEP_FIELD ='|';
      private
        class function AlignStr(const ALen: Integer;
                                const AStr: string;
                                const AChar: Char;
                                const Align: TAlignment=taLeftJustify): string;
        class function AlignLeft(const ALen: Integer;
                                 const AStr: string;
                                 const AChar: Char=' '): string;
        class function AlignRight(const ALen: Integer;
                                  const AStr: string;
                                  const AChar: Char='0'): string;
      public
        class function FDat(const AValue: TDateTime): string ;
        class function FCur(const AValue: Currency;
                            const ADefault:string=''
                            ): string ;
        class function FFlt(const AValue: Extended;
                            const AFormat:string='0.00';
                            const ADefault:string=''
                            ): string ;
        class function FInt(const AValue: Integer;
                            const ALen: Integer=0;
                            const ADefault:string=''
                            ): string ;
        class function FStr(const AValue: string;
                            const ALen:Integer=0;
                            const AFix:Boolean=False;
                            const ADefault:string=''
                            ): string;

        class function GetNumbers(const AValue: string): string	;
        class function IsNumber(const AValue: string): Boolean	;

        class function CFOP_ICMSST(const cfop: Word): Boolean	;

      end;


implementation

uses DateUtils,
  StrUtils;


{ Tefd_util }

class function Tefd_util.AlignLeft(const ALen: Integer;
                                   const AStr: string;
                                   const AChar: Char): string;
begin
    Result :=Self.AlignStr(ALen, AStr, AChar, taLeftJustify) ;
end;

class function Tefd_util.AlignRight(const ALen: Integer;
                                   const AStr: string;
                                   const AChar: Char): string;
begin
    Result :=Self.AlignStr(ALen, AStr, AChar, taRightJustify) ;
end;

class function Tefd_util.AlignStr(const ALen: Integer;
                                  const AStr: string;
                                  const AChar: Char;
                                  const Align: TAlignment): string;
var
    C,M:integer;
begin

    Result :=Copy(AStr, 1, ALen) ;
    if ALen>0 then
  	begin
        C :=ALen - Length(Result) ;
        case Align of
            taLeftJustify  :Result :=Result + StringOfChar(AChar, C) ;
            taRightJustify :Result :=StringOfChar(AChar, C) + Result ;
            taCenter       :begin
                                M :=Trunc(C/2)	;
                                Result :=Self.AlignStr(ALen, StringOfChar(AChar, ALen)+Result, AChar) ;
                            end;
        end;
    end;
end;

class function Tefd_util.CFOP_ICMSST(const cfop: Word): Boolean;
const
		arr_cfop_icmsst: array [0..21] of Word = (1401,
                                              1403,
                                              1406,
                                              1407,
                                              1408,
                                              1409,
                                              1410,
                                              1411,
                                              1414,
                                              1415,
                                              1603,
                                              2401,
                                              2403,
                                              2406,
                                              2407,
                                              2408,
                                              2409,
                                              2410,
                                              2411,
                                              2414,
                                              2415,
                                              2603);
var
  	I: Integer	;
begin
    Result :=False	;
  	for I :=Low(arr_cfop_icmsst) to High(arr_cfop_icmsst) do
    begin
      	if arr_cfop_icmsst[I] = cfop then
        begin
          	Result :=True	;
            Break ;
        end;
    end;
end;

class function Tefd_util.FCur(const AValue: Currency;
                              const ADefault: string): string;
const
    FORMAT_CUR='0.00' ;
var
    f:TFormatSettings;
begin
    Result :='';
    f.DecimalSeparator :=',';
    if AValue > 0 then
    begin
        Result	:=SysUtils.FormatCurr(FORMAT_CUR, AValue, f);
    end
    else
    begin
        if ADefault<>'' then
        begin
            Result :=SysUtils.FormatCurr(FORMAT_CUR, StrToCurrDef(ADefault,0), f);
        end;
    end;
end;

class function Tefd_util.FDat(const AValue: TDateTime): string;
begin
    if YearOf(AValue)> 1899 then
        Result	:=FormatDateTime('DDMMYYYY', AValue)
    else
        Result	:='';
end;

class function Tefd_util.FFlt(const AValue: Extended;
                              const AFormat, ADefault: string): string;
var
    f:TFormatSettings;
begin
    Result :='';
    f.DecimalSeparator :=',';
    if AValue > 0 then
    begin
        Result	:=SysUtils.FormatFloat(AFormat, AValue, f);
    end
    else
    begin
        if ADefault<>'' then
        begin
            Result :=SysUtils.FormatFloat(AFormat, StrToFloatDef(ADefault,0), f);
        end;
    end;
end;

class function Tefd_util.FInt(const AValue: Integer;
                              const ALen: Integer;
                              const ADefault: string): string;
var
    I: Integer ;
begin
    I	:=Abs(AValue) ;
    if I>0 then
    begin
        Result :=IntToStr(I)  ;
        if ALen>0 then
        begin
            Result :=Self.AlignRight(ALen, Result) ;
        end;
    end
    else
    begin
        Result  :=ADefault  ;
    end;
end;

class function Tefd_util.FStr(const AValue: string;
                              const ALen: Integer;
                              const AFix:Boolean;
                              const ADefault: string): string;
begin
    Result :=Trim(AValue)	;
    if Result<>'' then
    begin
        if ALen>0 then
        begin
            if Length(Result)>=ALen then
            begin
                Result :=Self.AlignLeft(ALen, Result)  ;
            end
            else
            begin
                if AFix then
                begin
                    if Self.IsNumber(AValue) then
                        Result :=Self.AlignRight(ALen, Result)
                    else
                        Result :=Self.AlignLeft(ALen, Result)  ;
                end;
            end;
        end ;
    end
    else
    begin
        Result :=ADefault ;
    end;
end;

class function Tefd_util.GetNumbers(const AValue: string): string;
var
    I:Integer	;
begin
  	Result	:='';
    for I:=1 to Length(AValue) do
    begin
        if AValue[I] in['0'..'9'] then
        begin
            Result :=Result +AValue[I]	;
        end;
    end;
end;

class function Tefd_util.IsNumber(const AValue: string): Boolean;
var
    S:String;
    I:Integer	;
begin
    S     :=Trim(AValue)  ;
  	Result:=Length(S)>0  ;
    if Result then
    begin
        for I:=1 to Length(S) do
        begin
            if not(S[I] in ['0'..'9']) then
            begin
                Result	:=False ;
                Break ;
            end;
        end;
    end;
end;


end.
