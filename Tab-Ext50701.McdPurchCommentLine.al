tableextension 50701 McdPurchCommentLine extends "Purch. Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "Print on Quote"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50701; "Print on Order"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50702; "Print on Receipt"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50703; "Print on Return"; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50704; "Print on Invoice"; boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    var myInt: Integer;
}
