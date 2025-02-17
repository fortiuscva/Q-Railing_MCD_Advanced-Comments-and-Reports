pageextension 50701 McdPurchCommentSheet extends "Purch. Comment Sheet"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Print on Invoice"; rec."Print on Invoice")
            {
                ApplicationArea = all;
            }
            field("Print on Order"; rec."Print on Order")
            {
                ApplicationArea = all;
            }
            field("Print on Quote"; rec."Print on Quote")
            {
                ApplicationArea = all;
            }
            field("Print on Receipt"; rec."Print on Receipt")
            {
                ApplicationArea = all;
            }
            field("Print on Return"; rec."Print on Return")
            {
                ApplicationArea = all;
            }
        }
    }
    var myInt: Integer;
}
