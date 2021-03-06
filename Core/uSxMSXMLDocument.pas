unit uSxMSXMLDocument;

interface

uses
  {$if CompilerVersion >= 25}Xml.Win.msxmldom{$else}msxmldom{$ifend},
  XMLDoc, XMLIntf, Classes, XMLDom,
  ActiveX;

function ReadChildNode(const XMLNode: IXMLNode; const NodeName: string): string;
function FindOrAddChild(const XMLNode: IXMLNode; const NodeName: string): IXMLNode;
procedure AddXMLHeader(const XML: IXMLDocument; const FileDescription: string);

type
  TSxMSXMLDocument = class(TXMLDocument)
  protected
    procedure SetActive(const Value: Boolean); override;
  public
    procedure SaveToFile(const AFileName: DOMString = ''); override;
    class procedure InitializeCOM;
    class procedure FinalizeCOM;
  end;

implementation

uses
  uStrings,
  uProjectInfo;

function ReadChildNode(const XMLNode: IXMLNode; const NodeName: string): string;
var
  Node: IXMLNode;
begin
  Node := XMLNode.ChildNodes.FindNode(NodeName);
  if Node <> nil then
    Result := Node.NodeValue
  else
    Result := '';
end;

function FindOrAddChild(const XMLNode: IXMLNode; const NodeName: string): IXMLNode;
begin
  Result := XMLNode.ChildNodes.FindNode(NodeName);
  if Result = nil then
    Result := XMLNode.AddChild(NodeName);
end;

function GetXMLComment(const FileDescription: string): string;
begin
  if FileDescription <> '' then
    Result := FileDescription + FileSep
  else
    Result := '';

  AppendStr(Result, GetProjectInfo(piProductName) + CharSpace + GetProjectInfo(piFileVersion) + FileSep);
  AppendStr(Result, GetProjectInfo(piLegalCopyright) + CharSpace + GetProjectInfo(piCompanyName) + FileSep);
  AppendStr(Result, GetProjectInfo(piWeb));
end;

procedure AddXMLHeader(const XML: IXMLDocument; const FileDescription: string);
begin
//  if XML.DocumentElement = nil then
  begin
    XML.ChildNodes.Add(XML.CreateNode(GetXMLComment(FileDescription), ntComment));
  end;
end;

{ TSxMSXMLDocument }

class procedure TSxMSXMLDocument.FinalizeCOM;
begin
	CoUninitialize;
end;

class procedure TSxMSXMLDocument.InitializeCOM;
begin
	Assert(CoInitializeEx(nil, COINIT_MULTITHREADED or COINIT_SPEED_OVER_MEMORY) <> S_FALSE);
{$if CompilerVersion >= 25}
  MSXMLDOMDocumentFactory.AddDOMProperty('ProhibitDTD', False);
{$else}
{$if CompilerVersion >= 21}
  MSXML6_ProhibitDTD := False;
{$ifend}
{$ifend}
end;

procedure TSxMSXMLDocument.SaveToFile(const AFileName: DOMString = '');
begin
  if Active then
  begin
    XML.Text := FormatXMLData(XML.Text);
    Active := True;
  end;
  inherited;
end;

procedure TSxMSXMLDocument.SetActive(const Value: Boolean);
begin
  // Change default options
//  Options := Options + [doNodeAutoIndent];

  inherited;
end;

end.
