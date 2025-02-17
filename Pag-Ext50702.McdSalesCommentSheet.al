pageextension 50702 McdSalesCommentSheet extends "Sales Comment Sheet"
{
    layout
    {
        modify("Print On Credit Memo")
        {
            Visible = true;
        }
        modify("Print On Invoice")
        {
            Visible = true;
        }
        modify("Print On Order Confirmation")
        {
            Visible = true;
        }
        modify("Print On Pick Ticket")
        {
            Visible = true;
        }
        modify("Print On Quote")
        {
            Visible = true;
        }
        modify("Print On Return Authorization")
        {
            Visible = true;
        }
        modify("Print On Return Receipt")
        {
            Visible = true;
        }
        modify("Print On Shipment")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field("Print on Blanket Order"; rec."Print on Blanket Order")
            {
                ApplicationArea = all;
            }
        }
    }
}
