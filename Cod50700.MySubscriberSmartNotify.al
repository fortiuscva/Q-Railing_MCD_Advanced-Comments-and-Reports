Codeunit 50700 "MySubscriberSmart_Notify"
{
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure ShowcommentsNotify(var Rec: record "Sales Header"; var Xrec: Record "Sales Header"; CUrrfieldno: integer)
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Customer);
        commentLine.setrange("No.", rec."Sell-to Customer No.");
        commentline.setrange("Notify User", true);
        if not commentline.findset then exit;
        CommentNotification.MESSAGE('There are Notifications for this Customer');
        CommentNotification.SCOPE:=NOTIFICATIONSCOPE::LocalScope;
        //Add a data property for the customer number
        CommentNotification.SETDATA('CustNumber', rec."Sell-to Customer No.");
        CommentNotification.SETDATA('TABLETYPE', format(Commentline."Table Name"));
        //Add an action that calls the ActionHandler codeunit, which you define in the next step.
        CommentNotification.ADDACTION('View Comments', CODEUNIT::"ActionHandler", 'OpenComment');
        //Send the notification to the client.
        CommentNotification.SEND;
    End;
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure ShowcommentsPONotify(var Rec: record "Purchase Header"; var Xrec: Record "Purchase Header"; CUrrfieldno: integer)
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Vendor);
        commentLine.setrange("No.", rec."Buy-from Vendor No.");
        commentline.setrange("Notify User", true);
        if not commentline.findset then exit;
        CommentNotification.MESSAGE('There are Notifications for this Vendor');
        CommentNotification.SCOPE:=NOTIFICATIONSCOPE::LocalScope;
        //Add a data property for the customer number
        CommentNotification.SETDATA('CustNumber', rec."Buy-from Vendor No.");
        CommentNotification.SETDATA('TABLETYPE', format(Commentline."Table Name"));
        //Add an action that calls the ActionHandler codeunit, which you define in the next step.
        CommentNotification.ADDACTION('View Comments', CODEUNIT::"ActionHandler", 'OpenComment');
        //Send the notification to the client.
        CommentNotification.SEND;
    End;
    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemValues', '', true, true)]
    Local procedure ShowcommentsSOline(var SalesLine: Record "Sales Line")
    // var Rec: record "Sales Line";
    //         var Xrec: Record "Sales Line";
    //      CUrrfieldno: integer)
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Item);
        commentLine.setrange("No.", SalesLine."No.");
        commentline.setrange("Notify User", true);
        if not commentline.findset then exit;
        clear(CommentNotification);
        CommentNotification.MESSAGE('There are Notifications for this Item');
        CommentNotification.SCOPE:=NOTIFICATIONSCOPE::LocalScope;
        //Add a data property for the customer number
        CommentNotification.SETDATA('CustNumber', SalesLine."No.");
        CommentNotification.SETDATA('TABLETYPE', format(Commentline."Table Name"));
        //Add an action that calls the ActionHandler codeunit, which you define in the next step.
        CommentNotification.ADDACTION('View Comments', CODEUNIT::"ActionHandler", 'OpenComment');
        //Send the notification to the client.
        CommentNotification.SEND;
    End;
    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure ShowcommentsPOline(var Rec: record "Purchase Line"; var Xrec: Record "Purchase Line"; CUrrfieldno: integer)
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Item);
        commentLine.setrange("No.", rec."No.");
        commentline.setrange("Notify User", true);
        if not commentline.findset then exit;
        CommentNotification.MESSAGE('There are Notifications for this Item');
        CommentNotification.SCOPE:=NOTIFICATIONSCOPE::LocalScope;
        //Add a data property for the customer number
        CommentNotification.SETDATA('CustNumber', rec."No.");
        CommentNotification.SETDATA('TABLETYPE', format(Commentline."Table Name"));
        //Add an action that calls the ActionHandler codeunit, which you define in the next step.
        CommentNotification.ADDACTION('View Comments', CODEUNIT::"ActionHandler", 'OpenComment');
        //Send the notification to the client.
        CommentNotification.SEND;
    End;
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterSelltoCustomerNoOnAfterValidate', '', true, true)]
    Local procedure ShowcommentsSales(var SalesHeader: Record "Sales Header");
    var
        Commentline: Record "Comment Line";
        SalesComment: Record "Sales Comment Line";
        CommentNotification: Notification;
    begin
        if SalesHeader."No." <> '' then begin
            commentline.reset;
            commentline.SetRange("Table Name", Commentline."Table Name"::Customer);
            commentLine.setrange("No.", SalesHeader."Sell-to Customer No.");
            if commentline.findset then begin
                SalesComment.reset;
                SalesComment.setrange("No.", SalesHeader."No.");
                SalesComment.setrange("Document Type", SalesHeader."Document Type");
                SalesComment.setrange("Document Line No.", 0);
                SalesComment.deleteall;
                repeat if CopyCommentLine(Commentline)then begin
                        SalesComment.init;
                        SalesComment."Document Type":=SalesHeader."Document Type";
                        SalesComment."No.":=SalesHeader."No.";
                        SalesComment.Code:=Commentline.Code;
                        SalesComment.Comment:=Commentline.Comment;
                        SalesComment.Date:=workdate;
                        SalesComment."Document Line No.":=0;
                        SalesComment."Line No.":=Commentline."Line No.";
                        SalesComment."Print On Credit Memo":=Commentline."Print on Credit Memo";
                        SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                        SalesComment."Print On Order Confirmation":=Commentline."Print on Confirmation";
                        SalesComment."Print On Pick Ticket":=Commentline."Print on Pick";
                        SalesComment."Print On Quote":=Commentline."Print on Quote";
                        SalesComment."Print On Return Authorization":=Commentline."Print on Return";
                        SalesComment."Print On Return Receipt":=Commentline."Print on Receipt";
                        SalesComment."Print On Shipment":=Commentline."Print on Shipment";
                        SalesComment."Print on Blanket Order":=Commentline."Print on Blanket Order";
                        SalesComment.insert;
                    end;
                until Commentline.next = 0;
            end;
        end;
    End;
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterOnInsert', '', true, true)]
    Local procedure Showcommentsinsert(var SalesHeader: Record "Sales Header");
    var
        Commentline: Record "Comment Line";
        SalesComment: Record "Sales Comment Line";
        CommentNotification: Notification;
    begin
        if SalesHeader."No." <> '' then begin
            commentline.reset;
            commentline.SetRange("Table Name", Commentline."Table Name"::Customer);
            commentLine.setrange("No.", SalesHeader."Sell-to Customer No.");
            if commentline.findset then begin
                SalesComment.reset;
                SalesComment.setrange("No.", SalesHeader."No.");
                SalesComment.setrange("Document Type", SalesHeader."Document Type");
                SalesComment.setrange("Document Line No.", 0);
                SalesComment.deleteall;
                repeat if CopyCommentLine(Commentline)then begin
                        SalesComment.init;
                        SalesComment."Document Type":=SalesHeader."Document Type";
                        SalesComment."No.":=SalesHeader."No.";
                        SalesComment.Code:=Commentline.Code;
                        SalesComment.Comment:=Commentline.Comment;
                        SalesComment.Date:=workdate;
                        SalesComment."Document Line No.":=0;
                        SalesComment."Line No.":=Commentline."Line No.";
                        SalesComment."Print On Credit Memo":=Commentline."Print on Credit Memo";
                        SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                        SalesComment."Print On Order Confirmation":=Commentline."Print on Confirmation";
                        SalesComment."Print On Pick Ticket":=Commentline."Print on Pick";
                        SalesComment."Print On Quote":=Commentline."Print on Quote";
                        SalesComment."Print On Return Authorization":=Commentline."Print on Return";
                        SalesComment."Print On Return Receipt":=Commentline."Print on Receipt";
                        SalesComment."Print On Shipment":=Commentline."Print on Shipment";
                        SalesComment."Print on Blanket Order":=Commentline."Print on Blanket Order";
                        SalesComment.insert;
                    end;
                until Commentline.next = 0;
            end;
        end;
    End;
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure ShowcommentsPO(var Rec: Record "Purchase Header")
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
        salescomment: Record "Purch. Comment Line";
    begin
        if rec."No." <> '' then begin
            commentline.reset;
            commentline.SetRange("Table Name", Commentline."Table Name"::Vendor);
            commentLine.setrange("No.", rec."Buy-from Vendor No.");
            if commentline.findset then begin
                SalesComment.reset;
                SalesComment.setrange("No.", rec."No.");
                SalesComment.setrange("Document Type", rec."Document Type");
                SalesComment.setrange("Document Line No.", 0);
                SalesComment.deleteall;
                repeat if CopyCommentLine(Commentline)then begin
                        SalesComment.init;
                        SalesComment."Document Type":=rec."Document Type";
                        SalesComment."No.":=rec."No.";
                        SalesComment.Code:=Commentline.Code;
                        SalesComment.Comment:=Commentline.Comment;
                        SalesComment.Date:=workdate;
                        SalesComment."Document Line No.":=0;
                        SalesComment."Line No.":=Commentline."Line No.";
                        SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                        SalesComment."Print On Order":=Commentline."Print on Purchase Order";
                        salescomment."Print on Quote":=Commentline."Print on Quote";
                        salescomment."Print on Receipt":=Commentline."Print on Purchase Receipt";
                        salescomment."Print on Return":=Commentline."Print on Return";
                        SalesComment.insert;
                    end;
                until Commentline.next = 0;
            End;
        end;
    end;
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', true, true)]
    Local procedure ShowcommentsPOinsert(var PurchHeader: Record "Purchase Header")
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
        salescomment: Record "Purch. Comment Line";
    begin
        if PurchHeader."No." <> '' then begin
            commentline.reset;
            commentline.SetRange("Table Name", Commentline."Table Name"::Vendor);
            commentLine.setrange("No.", PurchHeader."Buy-from Vendor No.");
            if commentline.findset then begin
                SalesComment.reset;
                SalesComment.setrange("No.", PurchHeader."No.");
                SalesComment.setrange("Document Type", PurchHeader."Document Type");
                SalesComment.setrange("Document Line No.", 0);
                SalesComment.deleteall;
                repeat if CopyCommentLine(Commentline)then begin
                        SalesComment.init;
                        SalesComment."Document Type":=PurchHeader."Document Type";
                        SalesComment."No.":=PurchHeader."No.";
                        SalesComment.Code:=Commentline.Code;
                        SalesComment.Comment:=Commentline.Comment;
                        SalesComment.Date:=workdate;
                        SalesComment."Document Line No.":=0;
                        SalesComment."Line No.":=Commentline."Line No.";
                        SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                        SalesComment."Print On Order":=Commentline."Print on Purchase Order";
                        salescomment."Print on Quote":=Commentline."Print on Quote";
                        salescomment."Print on Receipt":=Commentline."Print on Purchase Receipt";
                        salescomment."Print on Return":=Commentline."Print on Return";
                        SalesComment.insert;
                    end;
                until Commentline.next = 0;
            End;
        end;
    end;
    //Start here for pages.
    [EventSubscriber(ObjectType::Page, 41, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCustQuote(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 41, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustnamequote(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 42, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCust(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 42, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustname(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 43, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCustinv(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 43, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustnameinv(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 44, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCustCM(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 44, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustnameCM(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 507, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCustBlanketSO(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 507, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustnameblanketSO(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 6630, 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    Local procedure setsocommentsCustsoreturn(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 6630, 'OnAfterValidateEvent', 'Sell-to Customer Name', true, true)]
    Local procedure setsocommentsCustnamesoreturn(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    begin
        LOadSalesHeaderComments(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 50, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspo(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 50, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentspoVendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 49, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspquote(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 49, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentsquoteVendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 51, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspInvoice(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 51, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentsInvoicevendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 52, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspCM(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 52, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentsCMVendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 509, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspblanket(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 509, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentsblanketVendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6640, 'OnAfterValidateEvent', 'Buy-from Vendor No.', true, true)]
    Local procedure setcommentspReturn(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6640, 'OnAfterValidateEvent', 'Buy-from Vendor Name', true, true)]
    Local procedure setcommentsreturnVendName(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header");
    begin
        LoadPOHeaderComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 46, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure solinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 46, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure solinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 47, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure sinvlinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 47, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure sinvlinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 95, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure sQuotelinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 95, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure squotelinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 96, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure sCMlinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 96, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure sCMlinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 508, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure sblanketlinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 508, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure sblanketlinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6631, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure sReturnlinecomment(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6631, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure sreturnlinecommentDesc(var Rec: Record "Sales Line");
    begin
        loadSOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 54, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pOlinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 54, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PolinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    // Added 7/5/22 - RS (Correct PO From Req. Worksheet)
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure POLineCommentInsert(var Rec: Record "Purchase Line")
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure POLineCommentDescInsert(var Rec: Record "Purchase Line")
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 55, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pINVlinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 55, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PINVlinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 97, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pquotelinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 97, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PquotelinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 98, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pCMlinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 98, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PCMlinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 510, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pBlanketlinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 510, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PBlanketlinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6641, 'OnAfterValidateEvent', 'No.', true, true)]
    Local procedure pReturnlinecomment(var Rec: Record "Purchase Line");
    begin
        LoadPOlineComments(rec);
    end;
    [EventSubscriber(ObjectType::Page, 6641, 'OnAfterValidateEvent', 'Description', true, true)]
    Local procedure PreturnlinecommentDesc(var Rec: Record "Purchase Line");
    begin
        loadpOLineComments(rec);
    end;
    procedure LOadSalesHeaderComments(var SalesHeader: Record "Sales Header")
    var
        Commentline: Record "Comment Line";
        SalesComment: Record "Sales Comment Line";
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Customer);
        commentLine.setrange("No.", SalesHeader."Sell-to Customer No.");
        if commentline.findset then begin
            SalesComment.reset;
            SalesComment.setrange("No.", SalesHeader."No.");
            SalesComment.setrange("Document Type", SalesHeader."Document Type");
            SalesComment.setrange("Document Line No.", 0);
            SalesComment.deleteall;
            repeat if CopyCommentLine(Commentline)then begin
                    SalesComment.init;
                    SalesComment."Document Type":=SalesHeader."Document Type";
                    SalesComment."No.":=SalesHeader."No.";
                    SalesComment.Code:=Commentline.Code;
                    SalesComment.Comment:=Commentline.Comment;
                    SalesComment.Date:=workdate;
                    SalesComment."Document Line No.":=0;
                    SalesComment."Line No.":=Commentline."Line No.";
                    SalesComment."Print On Credit Memo":=Commentline."Print on Credit Memo";
                    SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                    SalesComment."Print On Order Confirmation":=Commentline."Print on Confirmation";
                    SalesComment."Print On Pick Ticket":=Commentline."Print on Pick";
                    SalesComment."Print On Quote":=Commentline."Print on Quote";
                    SalesComment."Print On Return Authorization":=Commentline."Print on Return";
                    SalesComment."Print On Return Receipt":=Commentline."Print on Receipt";
                    SalesComment."Print On Shipment":=Commentline."Print on Shipment";
                    SalesComment."Print on Blanket Order":=Commentline."Print on Blanket Order";
                    SalesComment.insert;
                end;
            until Commentline.next = 0;
        end;
    end;
    procedure loadSOLineComments(var Rec: record "Sales Line")
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
        SalesComment: Record "Sales Comment Line";
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Item);
        commentLine.setrange("No.", rec."No.");
        if commentline.findset then begin
            SalesComment.reset;
            SalesComment.setrange("No.", rec."Document No.");
            SalesComment.setrange("Document Type", rec."Document Type");
            SalesComment.setrange("Document Line No.", rec."Line No.");
            SalesComment.deleteall;
            repeat if CopyCommentLine(Commentline)then begin
                    SalesComment.init;
                    SalesComment."Document Type":=rec."Document Type";
                    SalesComment."No.":=rec."Document No.";
                    SalesComment.Code:=Commentline.Code;
                    SalesComment.Comment:=Commentline.Comment;
                    SalesComment.Date:=workdate;
                    SalesComment."Document Line No.":=rec."Line No.";
                    SalesComment."Line No.":=Commentline."Line No.";
                    SalesComment."Print On Credit Memo":=Commentline."Print on Credit Memo";
                    SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                    SalesComment."Print On Order Confirmation":=Commentline."Print on Confirmation";
                    SalesComment."Print On Pick Ticket":=Commentline."Print on Pick";
                    SalesComment."Print On Quote":=Commentline."Print on Quote";
                    SalesComment."Print On Return Authorization":=Commentline."Print on Return";
                    SalesComment."Print On Return Receipt":=Commentline."Print on Receipt";
                    SalesComment."Print On Shipment":=Commentline."Print on Shipment";
                    SalesComment."Print on Blanket Order":=Commentline."Print on Blanket Order";
                    SalesComment.insert;
                end;
            until Commentline.next = 0;
        End;
    end;
    procedure LoadPOHeaderComments(var PurchaseHeader: Record "Purchase Header")
    var
        Commentline: Record "Comment Line";
        salescomment: Record "Purch. Comment Line";
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Vendor);
        commentLine.setrange("No.", PurchaseHeader."Buy-from Vendor No.");
        if commentline.findset then begin
            SalesComment.reset;
            SalesComment.setrange("No.", PurchaseHeader."No.");
            SalesComment.setrange("Document Type", PurchaseHeader."Document Type");
            SalesComment.setrange("Document Line No.", 0);
            SalesComment.deleteall;
            repeat if CopyCommentLine(Commentline)then begin
                    SalesComment.init;
                    SalesComment."Document Type":=PurchaseHeader."Document Type";
                    SalesComment."No.":=PurchaseHeader."No.";
                    SalesComment.Code:=Commentline.Code;
                    SalesComment.Comment:=Commentline.Comment;
                    SalesComment.Date:=workdate;
                    SalesComment."Document Line No.":=0;
                    SalesComment."Line No.":=Commentline."Line No.";
                    SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                    SalesComment."Print On Order":=Commentline."Print on Purchase Order";
                    salescomment."Print on Quote":=Commentline."Print on Quote";
                    salescomment."Print on Receipt":=Commentline."Print on Purchase Receipt";
                    salescomment."Print on Return":=Commentline."Print on Return";
                    SalesComment.insert;
                end;
            until Commentline.next = 0;
        End;
    end;
    procedure LoadPOlineComments(var Rec: record "Purchase Line");
    var
        Commentline: Record "Comment Line";
        CommentNotification: Notification;
        salescomment: Record "Purch. Comment Line";
    begin
        commentline.reset;
        commentline.SetRange("Table Name", Commentline."Table Name"::Item);
        commentLine.setrange("No.", rec."No.");
        if commentline.findset then begin
            SalesComment.reset;
            SalesComment.setrange("No.", rec."Document No.");
            SalesComment.setrange("Document Type", rec."Document Type");
            SalesComment.setrange("Document Line No.", rec."Line No.");
            SalesComment.deleteall;
            repeat if CopyCommentLine(Commentline)then begin
                    SalesComment.init;
                    SalesComment."Document Type":=rec."Document Type";
                    SalesComment."No.":=rec."Document No.";
                    SalesComment.Code:=Commentline.Code;
                    SalesComment.Comment:=Commentline.Comment;
                    SalesComment.Date:=workdate;
                    SalesComment."Document Line No.":=rec."Line No.";
                    SalesComment."Line No.":=Commentline."Line No.";
                    SalesComment."Print On Invoice":=Commentline."Print on Invoice";
                    SalesComment."Print On Order":=Commentline."Print on Purchase Order";
                    salescomment."Print on Quote":=Commentline."Print on Quote";
                    salescomment."Print on Receipt":=Commentline."Print on Purchase Receipt";
                    salescomment."Print on Return":=Commentline."Print on Return";
                    SalesComment.insert;
                end;
            until Commentline.next = 0;
        End;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Comment Line", 'OnBeforeCopyComments', '', true, true)]
    local procedure PreventDuplicateComment(FromDocumentType: Integer; FromNumber: Code[20]; var IsHandled: Boolean; ToDocumentType: Integer; ToNumber: Code[20])
    var
        SalesCommentLineFrom: Record "Sales Comment Line";
        SalesCommentLineTo: Record "Sales Comment Line";
        LineNo: Integer;
    begin
        SalesCommentLineFrom.Reset();
        SalesCommentLineFrom.SetRange("Document Type", FromDocumentType);
        SalesCommentLineFrom.SetRange("No.", FromNumber);
        if SalesCommentLineFrom.FindSet()then repeat SalesCommentLineTo.Reset();
                SalesCommentLineTo.SetRange("Document Type", ToDocumentType);
                SalesCommentLineTo.SetRange("No.", ToNumber);
                if SalesCommentLineTo.Find('-')then begin // Comments already created by Subscriber
                    SalesCommentLineTo.SetRange(Comment, SalesCommentLineFrom.Comment);
                    if not SalesCommentLineTo.Find('-')then begin
                        SalesCommentLineTo.Reset();
                        SalesCommentLineTo.SetRange("Document Type", ToDocumentType);
                        SalesCommentLineTo.SetRange("No.", ToNumber);
                        SalesCommentLineTo.SetAscending("Line No.", false);
                        if SalesCommentLineTo.Find('-')then LineNo:=SalesCommentLineTo."Line No." + 10000
                        else
                            LineNo:=10000;
                        SalesCommentLineTo:=SalesCommentLineFrom;
                        SalesCommentLineTo."Document Type":="Sales Comment Document Type".FromInteger(ToDocumentType);
                        SalesCommentLineTo."No.":=ToNumber;
                        SalesCommentLineTo."Line No.":=LineNo;
                        SalesCommentLineTo.Insert();
                    end;
                    IsHandled:=true;
                end;
            until SalesCommentLineFrom.Next() = 0;
    end;
    local procedure CopyCommentLine(CommentLine: Record "Comment Line"): Boolean begin
        // if CommentLine."Notify User" then begin
        //     // SalesComment."Print On Credit Memo" := Commentline."Print on Credit Memo";
        //     // SalesComment."Print On Invoice" := Commentline."Print on Invoice";
        //     // SalesComment."Print On Order Confirmation" := Commentline."Print on Confirmation";
        //     // SalesComment."Print On Pick Ticket" := Commentline."Print on Pick";
        //     // SalesComment."Print On Quote" := Commentline."Print on Quote";
        //     // SalesComment."Print On Return Authorization" := Commentline."Print on Return";
        //     // SalesComment."Print On Return Receipt" := Commentline."Print on Receipt";
        //     // SalesComment."Print On Shipment" := Commentline."Print on Shipment";
        //     // SalesComment."Print on Blanket Order" := Commentline."Print on Blanket Order";
        //     // SalesComment."Print On Invoice" := Commentline."Print on Invoice";
        //     // SalesComment."Print On Order" := Commentline."Print on Purchase Order";
        //     // salescomment."Print on Quote" := Commentline."Print on Quote";
        //     // salescomment."Print on Receipt" := Commentline."Print on Purchase Receipt";
        //     // salescomment."Print on Return" := Commentline."Print on Return";
        if Commentline."Print On Credit Memo" then exit(true);
        if CommentLine."Print On Invoice" then exit(true);
        if CommentLine."Print on Confirmation" then exit(true);
        if CommentLine."Print on Pick" then exit(true);
        if CommentLine."Print On Quote" then exit(true);
        if CommentLine."Print on Return" then exit(true);
        if CommentLine."Print on Receipt" then exit(true);
        if CommentLine."Print On Shipment" then exit(true);
        if CommentLine."Print on Blanket Order" then exit(true);
        if CommentLine."Print on Purchase Order" then exit(true);
        if CommentLine."Print on Purchase Receipt" then exit(true);
        exit(false);
    // end else
    //     exit(false);
    //  exit(CommentLine."Notify User");
    end;
}
