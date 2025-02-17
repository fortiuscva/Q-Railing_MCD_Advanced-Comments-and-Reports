pageextension 50700 McdCommentSheet extends "Comment Sheet" //MyTargetPageId
{
    layout
    {
        addafter(Comment)
        {
            field("Notify User"; rec."Notify User")
            {
                ApplicationArea = All;
            }
            field("Print on Blanket Order"; rec."Print on Blanket Order")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Confirmation"; rec."Print on Confirmation")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Pick"; rec."Print on Pick")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Shipment"; rec."Print on Shipment")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Return"; rec."Print on Return")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Invoice"; rec."Print on Invoice")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Credit Memo"; rec."Print on Credit Memo")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Quote"; rec."Print on Quote")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print On Return Receipt"; rec."Print On Receipt")
            {
                ApplicationArea = all;
                Visible = CustomerComment;
            }
            field("Print on Purchase Order"; rec."Print on Purchase Order")
            {
                ApplicationArea = all;
                Visible = vendorcomment;
            }
            field("Print on Purchase Receipt"; rec."Print on Purchase Receipt")
            {
                ApplicationArea = all;
                Visible = vendorcomment;
            }
        }
    }
    var CustomerComment: Boolean;
    vendorcomment: Boolean;
    trigger OnOpenPage()
    begin
        CustomerComment:=false;
        vendorcomment:=false;
        if rec."Table Name" = rec."Table Name"::Customer then CustomerComment:=true;
        if rec."Table Name" = rec."Table Name"::Vendor then vendorComment:=true;
        if rec."Table Name" = rec."Table Name"::item then begin
            CustomerComment:=true;
            vendorcomment:=true;
        end;
    end;
}
