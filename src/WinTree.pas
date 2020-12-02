(*  GREATIS WINDOWSE                          *)
(*  unit version 5.10.001                     *)
(*  Copyright (C) 1999-2003 Greatis Software  *)
(*  http://www.greatis.com/windowse.htm       *)
(*  b-team@greatis.com                        *)

unit WinTree;

interface

uses Windows, ComCtrls, Classes, SysUtils;

type
  PChildRec = ^TChildRec;
  TChildRec = record
    TreeView: TTreeView;
    ParentWindow: HWND;
    Item: TTreeNode;
  end;

function FindNode(TreeView: TTreeView; WND: HWND): TTreeNode;
function FindNodeByStrings(TreeView: TTreeView; StartFrom: TTreeNode; Up: Boolean; WindowText,WindowClass: string): TTreeNode;
procedure AddWindows(WND: HWND; CR: PChildRec);

implementation

function FindNode(TreeView: TTreeView; WND: HWND): TTreeNode;
var
  i: Integer;
begin
  Result:=nil;
  with TreeView,Items do
    for i:=0 to Pred(Count) do
      if HWND(Items[i].Data)=WND then
      begin
        Result:=Items[i];
        Break;
      end;
end;

function FindNodeByStrings(TreeView: TTreeView; StartFrom: TTreeNode; Up: Boolean; WindowText,WindowClass: string): TTreeNode;

var
  i: Integer;

  function NodeOK(TheNode: TTreeNode): Boolean;
  var
    T,C: array[0..16384] of Char;
  begin
    with TheNode do
    begin
      GetWindowText(HWND(Data),T,SizeOf(T));
      GetClassName(HWND(Data),C,SizeOf(C));
    end;
    Result:=((WindowText='') or (Pos(WindowText,AnsiUpperCase(T))<>0)) and
      ((WindowClass='') or (Pos(WindowClass,AnsiUpperCase(C))<>0));
  end;

begin
  Result:=nil;
  WindowText:=AnsiUpperCase(WindowText);
  WindowClass:=AnsiUpperCase(WindowClass);
  with TreeView,Items do
    if Up then
    begin
      for i:=Pred(StartFrom.AbsoluteIndex) downto 0 do
        if NodeOK(Items[i]) then
        begin
          Result:=Items[i];
          Break;
        end;
    end
    else
      for i:=Succ(StartFrom.AbsoluteIndex) to Pred(Count) do
        if NodeOK(Items[i]) then
        begin
          Result:=Items[i];
          Break;
        end;
end;

function EnumChildren(WND: HWND; CR: PChildRec): BOOL; stdcall;
var
  ICR: TChildRec;
  C,T: array[0..1024] of Char;
begin
  Result:=True;
  with CR^ do
    if (GetParent(WND)=ParentWindow) or (GetWindowLong(WND,GWL_STYLE) and WS_CHILD = 0) then
    begin
      ICR.ParentWindow:=WND;
      GetClassName(WND,C,SizeOf(C));
      GetWindowText(WND,T,SizeOf(T));
      ICR.Item:=Item.Owner.AddChildObjectFirst(Item,Format('"%s" (%s)',[T,C]),Pointer(WND));
      AddWindows(WND,@ICR);
    end;
end;

procedure AddWindows(WND: HWND; CR: PChildRec);
begin
  EnumChildWindows(WND,@EnumChildren,Integer(CR));
end;

end.
