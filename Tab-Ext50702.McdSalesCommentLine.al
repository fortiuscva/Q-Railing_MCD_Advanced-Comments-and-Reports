tableextension 50702 McdSalesCommentLine extends "Sales Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50700; "Print on Blanket Order"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    var myInt: Integer;
}
