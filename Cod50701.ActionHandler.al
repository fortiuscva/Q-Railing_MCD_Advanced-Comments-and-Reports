codeunit 50701 "ActionHandler"
{
    trigger OnRun()
    begin
    end;
    procedure OpenComment(CommentNotification: Notification)
    var
        // CustNumber: Text;
        // TABLETYPE:Text;
        CustNo: Text;
        tableval: text;
        commentline: Record "Comment Line";
        CommentPage: Page "Comment Sheet";
    begin
        //Get the customer number data from the SETDATA call.
        CustNo:=CommentNotification.GETDATA('CustNumber');
        tableval:=CommentNotification.GETDATA('TABLETYPE');
        // Open the Customer Card page for the customer.
        commentline.reset;
        if tableval = 'Customer' then commentline.setrange("Table Name", commentline."Table Name"::Customer);
        if tableval = 'Vendor' then commentline.setrange("Table Name", commentline."Table Name"::Vendor);
        if tableval = 'Item' then commentline.setrange("Table Name", commentline."Table Name"::Item);
        commentline.setrange("No.", Custno);
        commentline.setrange("Notify User", true);
        if commentline.findset then //begin
 //commentpage.SetRecord(Commentline);
            //commentpage.Editable(false);
            //commentline.setrecfilter;
            //CommentPage.SetRecord(commentline);
            //CommentPage.run;
            page.run(124, commentline);
    end;
}
