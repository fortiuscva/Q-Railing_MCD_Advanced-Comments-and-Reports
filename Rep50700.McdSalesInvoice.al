report 50700 "Mcd Sales Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/McdSalesInvoice.rdl';
    Caption = 'Sales - Invoice';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';

            column(No_SalesInvHeader; "No.")
            {
            }
            column(payamount; -1 * payamount)
            {
            }
            column(remainamount; remainamount)
            {
            }
            column(remainint; remainint)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                CalcFields = McdInnerSalespersonCode, McdOuterSalespersonCode;

                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");

                    trigger OnAfterGetRecord()
                    begin
                        i += 1;
                        ilerec.RESET;
                        ilerec.GET("Value Entry"."Item Ledger Entry No.");
                        IF (ilerec."Serial No." = '') and (ilerec."Lot No." = '') THEN CurrReport.SKIP;
                        IF i = 1 THEN begin
                            if ilerec."Serial No." <> '' then
                                serialtext := 'Serial No. : ' + ilerec."Serial No."
                            else
                                serialtext := 'Lot No. : ' + ilerec."Lot No."
                        end
                        ELSE begin
                            if ilerec."Serial No." <> '' then
                                serialtext := ilerec."Serial No."
                            else
                                serialtext := ilerec."Lot No.";
                        end;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        IF NEXT <> 0 THEN BEGIN
                            ilerec.RESET;
                            ilerec.GET("Value Entry"."Item Ledger Entry No.");
                            if ilerec."Serial No." <> '' then
                                serialtext += ',' + ilerec."Serial No."
                            else
                                serialtext += ',' + ilerec."Lot No.";
                        END;
                        WITH TempSalesInvoiceLine DO BEGIN
                            INIT;
                            "Document No." := "Sales Invoice Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(serialtext) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                            TempSalesInvoiceLine.Description := serialtext;
                            TempSalesInvoiceLine."Description 2" := '';
                        END
                        ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (serialtext[SpacePointer] <> ' ') DO SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := COPYSTR(serialtext, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" := COPYSTR(COPYSTR(serialtext, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                        END;
                        TempSalesInvoiceLine.INSERT;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT PrintSerial THEN CurrReport.BREAK;
                    end;
                }
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Invoice"), "Print On Invoice" = CONST(True));

                    trigger OnAfterGetRecord()
                    begin
                        WITH TempSalesInvoiceLine DO BEGIN
                            INIT;
                            "Document No." := "Sales Invoice Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        END
                        ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                        END;
                        TempSalesInvoiceLine.INSERT;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if skipzerolines then
                        if type = type::item then
                            if quantity = 0 then
                                CurrReport.skip;
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.INSERT;
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.INSERT;
                    HighestLineNo := "Line No.";
                    i := 0;
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesInvoiceLine.RESET;
                    TempSalesInvoiceLine.DELETEALL;
                    TempSalesInvoiceLineAsm.RESET;
                    TempSalesInvoiceLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Posted Invoice"), "Print On Invoice" = CONST(true), "Document Line No." = CONST(0));

                column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    j += 1;
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    // if j = 1 then
                    comment := comment;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                        if j = 1 then
                            TempSalesInvoiceLine.Description := 'Order Comments: ' + comment
                        else
                            TempSalesInvoiceLine."Description" := Comment;
                        //TempSalesInvoiceLine.Description := Comment;
                        TempSalesInvoiceLine."Description 2" := '';
                    END
                    ELSE BEGIN
                        SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO SpacePointer := SpacePointer - 1;
                        IF SpacePointer = 1 THEN SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesInvoiceLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                    END;
                    TempSalesInvoiceLine.INSERT;
                end;

                trigger OnPreDataItem()
                begin
                    WITH TempSalesInvoiceLine DO BEGIN
                        INIT;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    END;
                    TempSalesInvoiceLine.INSERT;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(ShipmentMethodDescription; "Sales Invoice Header"."Shipping Agent Code")
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesInvHeader; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(OrderDate_SalesInvHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(InnerSalesPurchPersonCode; ISPValue)
                    {
                    }
                    column(OuterSalesPurchPersonCode; OSPValue)
                    {
                    }

                    column(DocumentDate_SalesInvHeader; "Sales Invoice Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(DocumentText; DocumentText)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(InnerSalesPersonCaption; InnerSalesPersonCaptionLbl)
                    {
                    }
                    column(OuterSalesPersonCaption; OuterSalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    dataitem(SalesInvLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);

                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; LowDescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint; HighDescriptionToPrint)
                        {
                        }
                        column(linetype; format(TempsalesInvoiceline.type))
                        {
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaption)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaption)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaption)
                        {
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number);

                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE BEGIN
                                    TempPostedAsmLine.NEXT;
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                END;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            TempSalesInvoiceLine.SetAutoCalcFields(McdInnerSalespersonCode, McdOuterSalespersonCode);
                            WITH TempSalesInvoiceLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FIND('-')
                                ELSE
                                    NEXT;
                                OrderedQuantity := 0;
                                IF "Sales Invoice Header"."Order No." = '' THEN
                                    OrderedQuantity := Quantity
                                ELSE IF OrderLine.GET(1, "Sales Invoice Header"."Order No.", "Line No.") THEN
                                    OrderedQuantity := OrderLine.Quantity
                                ELSE BEGIN
                                    ShipmentLine.SETRANGE("Order No.", "Sales Invoice Header"."Order No.");
                                    ShipmentLine.SETRANGE("Order Line No.", "Line No.");
                                    IF ShipmentLine.FIND('-') THEN
                                        REPEAT
                                            OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                        UNTIL 0 = ShipmentLine.NEXT;
                                END;
                                DescriptionToPrint := Description + ' ' + "Description 2";
                                IF Type = 0 THEN BEGIN
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Amount := 0;
                                    "Amount Including VAT" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                END; //ELSE
                                // IF Type = Type::"G/L Account" THEN
                                //    "No." := '';
                                //IF "No." = '' THEN BEGIN
                                //  HighDescriptionToPrint := DescriptionToPrint;
                                //  LowDescriptionToPrint := '';
                                //END ELSE BEGIN
                                // HighDescriptionToPrint := '';
                                // LowDescriptionToPrint := DescriptionToPrint;
                                //END;
                                LowDescriptionToPrint := DescriptionToPrint;
                                IF Amount <> "Amount Including VAT" THEN
                                    TaxLiable := Amount
                                ELSE
                                    TaxLiable := 0;
                                AmountExclInvDisc := Amount + "Inv. Discount Amount";
                                IF Quantity = 0 THEN
                                    UnitPriceToPrint := 0 // so it won't print
                                ELSE
                                    UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);
                            END;
                            CollectAsmInformation(TempSalesInvoiceLine);

                            if Salesperson.Get(TempSalesInvoiceLine.McdInnerSalespersonCode) then
                                ISPValue := Salesperson.Name
                            else
                                ISPValue := '';

                            // Fetch the Outer Salesperson name
                            if Salesperson.Get(TempSalesInvoiceLine.McdOuterSalespersonCode) then
                                OSPValue := Salesperson.Name
                            else
                                OSPValue := '';
                        end;

                        trigger OnPreDataItem()
                        begin
                            CLEAR(TaxLiable);
                            CLEAR(AmountExclInvDisc);
                            NumberOfLines := TempSalesInvoiceLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                        end;
                    }
                    dataitem(LineFee; Integer)
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(1 ..));

                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            IF NOT DisplayAdditionalFeeNote THEN CurrReport.BREAK;
                            IF Number = 1 THEN BEGIN
                                IF NOT TempLineFeeNoteOnReportHist.FINDSET THEN CurrReport.BREAK
                            END
                            ELSE IF TempLineFeeNoteOnReportHist.NEXT = 0 THEN CurrReport.BREAK;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    CurrReport.PAGENO := 1;
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN SalesInvPrinted.RUN("Sales Invoice Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";
                    IF NoLoops <= 0 THEN NoLoops := 1;
                    CopyNo := 0;
                end;
            }
            trigger OnAfterGetRecord()
            var
                Custledg: Record "Cust. Ledger Entry";
            begin
                payamount := 0;
                remainamount := 0;
                remainint := 0;
                if showremain then begin
                    remainint := 1;
                    CalcFields(Amount, "Amount Including VAT", "Remaining Amount");
                    //  Custledg.reset;
                    //  Custledg.SetCurrentKey("Document No.", "Posting Date");
                    //  Custledg.setrange("Document No.", "No.");
                    //  custledg.setrange("Posting Date", workdate);
                    //  if Custledg.findset then begin
                    //      CalcFields("Remaining Amount", Amount);
                    //   if Custledg."Remaining Amount" <> Custledg.Amount then begin
                    payamount := "Amount Including VAT" - "Remaining Amount";
                    remainamount := "Remaining Amount";
                    //   end;
                    // end;
                end;
                IF PrintCompany THEN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        //   CompanyInformation."Phone No." := RespCenter."Phone No.";
                        //   CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                IF CompanyAddress[4] = '' THEN BEGIN
                    CompanyAddress[4] := 'Phone No.:' + CompanyInformation."Phone No.";
                    CompanyAddress[5] := 'E-Mail: ' + CompanyInformation."e-mail";
                END
                ELSE BEGIN
                    CompanyAddress[5] := 'Phone No.:' + CompanyInformation."Phone No.";
                    CompanyAddress[6] := 'E-Mail: ' + CompanyInformation."E-mail";
                END;
                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");
                IF NOT Customer.GET("Bill-to Customer No.") THEN BEGIN
                    CLEAR(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                j := 0;
                DocumentText := USText000;
                IF "Prepayment Invoice" THEN DocumentText := USText001;
                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");
                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");
                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, GLSetup."LCY Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaptionTxt, GLSetup."LCY Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaptionTxt, GLSetup."LCY Code");
                END
                ELSE BEGIN
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, "Currency Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaption, "Currency Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaption, "Currency Code");
                END;
                GetLineFeeNoteOnReportHist("No.");
                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code", "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code", "Campaign No.", "Posting Description", '');
                    END;
                CLEAR(BreakdownTitle);
                CLEAR(BreakdownLabel);
                CLEAR(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxArea.GET("Tax Area Code");
                    CASE TaxArea."Country/Region" OF
                        TaxArea."Country/Region"::US:
                            TotalTaxLabel := Text005;
                        TaxArea."Country/Region"::CA:
                            BEGIN
                                TotalTaxLabel := Text007;
                                TaxRegNo := CompanyInformation."VAT Registration No.";
                                TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                            END;
                    END;
                    SalesTaxCalc.StartSalesTaxCalculation;
                    IF TaxArea."Use External Tax Engine" THEN
                        SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Invoice Header", 0, "No.")
                    ELSE BEGIN
                        SalesTaxCalc.AddSalesInvoiceLines("No.");
                        SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    END;
                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                    BrkIdx := 0;
                    PrevPrintOrder := 0;
                    PrevTaxPercent := 0;
                    WITH TempSalesTaxAmtLine DO BEGIN
                        RESET;
                        SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                        IF FIND('-') THEN
                            REPEAT
                                IF ("Print Order" = 0) OR ("Print Order" <> PrevPrintOrder) OR ("Tax %" <> PrevTaxPercent) THEN BEGIN
                                    BrkIdx := BrkIdx + 1;
                                    IF BrkIdx > 1 THEN BEGIN
                                        IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
                                            BreakdownTitle := Text006
                                        ELSE
                                            BreakdownTitle := Text003;
                                    END;
                                    IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
                                        BrkIdx := BrkIdx - 1;
                                        BreakdownLabel[BrkIdx] := Text004;
                                    END
                                    ELSE
                                        BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
                                END;
                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                            UNTIL NEXT = 0;
                    END;
                    IF BrkIdx = 1 THEN BEGIN
                        CLEAR(BreakdownLabel);
                        CLEAR(BreakdownAmt);
                    END;
                END;
                SSI_Update_BillTo_ShipTo_Address(BillToAddress, ShipToAddress, "Sales Invoice Header");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies that you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
                    }
                    field(PrintSerial; PrintSerial)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Serial/Lot Numbers';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
                    }
                    field(showremain; showremain)
                    {
                        ApplicationArea = all;
                        caption = 'Show Remaining Amount Due';
                    }
                    field(skipzerolines; skipzerolines)
                    {
                        applicationarea = all;
                        Caption = 'Skip Zero Quantity Item Lines';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
            OnAfterInitialize(NoCopies, PrintCompany);
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            PrintCompany := true;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        GLSetup.GET;
    end;

    trigger OnPreReport()
    begin
        ShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        IF NOT CurrReport.USEREQUESTPAGE THEN InitLogInteraction;
        CompanyInformation.GET;
        SalesSetup.GET;
        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;
        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
        Text000 := 'COPY';
    end;

    protected var
        Salesperson: Record "Salesperson/Purchaser";
        ISPValue: Text;
        OSPValue: Text;
        Text000: Text[30]; //Label 'COPY';
        CopyTxt: Text;
        CopyNo: Integer;
        PrintSerial: Boolean;
        NoCopies: Integer;
        PrintCompany: Boolean;
        LogInteraction: Boolean;
        [InDataSet]
        DisplayAssemblyInformation: Boolean;
        DisplayAdditionalFeeNote: Boolean;
        showremain: Boolean;
        ilerec: Record "Item Ledger Entry";
        i: Integer;
        serialtext: Text[240];
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";

        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales INvoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        GLSetup: Record "General Ledger Setup";
        CompanyAddress: array[8] of Text[100];
        BillToAddress: array[8] of Text[100];
        ShipToAddress: array[8] of Text[100];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        NoLoops: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        TaxRegNo: Text;
        TaxRegLabel: Text;
        TotalTaxLabel: Text;
        BreakdownTitle: Text;
        BreakdownLabel: array[4] of Text;
        BreakdownAmt: array[4] of Decimal;
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID INVOICE';
        DocumentText: Text[20];
        USText000: Label 'SALES INVOICE';
        USText001: Label 'PREPAYMENT REQUEST';
        [InDataSet]
        LogInteractionEnable: Boolean;
        BillCaptionLbl: Label 'Bill';
        ToCaptionLbl: Label 'To:';
        ShipViaCaptionLbl: Label 'SHIP VIA';
        ShipDateCaptionLbl: Label 'SHIP DATE';
        DueDateCaptionLbl: Label 'DUE DATE';
        TermsCaptionLbl: Label 'TERMS';
        CustomerIDCaptionLbl: Label 'CUSTOMER NO.';
        PONumberCaptionLbl: Label 'P.O. NO.';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'Our Order No.';
        SalesPersonCaptionLbl: Label 'SALESPERSON';
        InnerSalesPersonCaptionLbl: Label 'I.S.P';
        OuterSalesPersonCaptionLbl: Label 'O.S.P';
        ShipCaptionLbl: Label 'Ship';
        InvoiceNumberCaptionLbl: Label 'INVOICE NO.';
        InvoiceDateCaptionLbl: Label 'DATE';
        PageCaptionLbl: Label 'Page:';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: Label 'Item/Description';
        UnitCaptionLbl: Label 'Unit';
        OrderQtyCaptionLbl: Label 'Order Qty';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionTxt: Label 'Total %1:';
        AmountSubjecttoSalesTaxCaptionTxt: Label 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: Label 'Amount Exempt from Sales Tax %1';
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        j: Integer;
        payamount: Decimal;
        remainamount: Decimal;
        remainint: Integer;
        skipzerolines: boolean;
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;

    var
    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary)
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DELETEALL;
        IF NOT DisplayAssemblyInformation THEN EXIT;
        IF NOT TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") THEN EXIT;
        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        IF SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item THEN EXIT;
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", SalesInvoiceLine."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
            SETRANGE("Applies-to Entry", 0);
            IF NOT FINDSET THEN EXIT;
        END;
        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
        UNTIL ValueEntry.NEXT = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        END
        ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DELETEALL;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
        IF NOT CustLedgerEntry.FINDFIRST THEN EXIT;
        IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN EXIT;
        LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
        IF LineFeeNoteOnReportHist.FINDSET THEN BEGIN
            REPEAT
                TempLineFeeNoteOnReportHist.INIT;
                TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.INSERT;
            UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END
        ELSE BEGIN
            //LineFeeNoteOnReportHist.SETRANGE("Language Code",Language.GetUserLanguage);
            IF LineFeeNoteOnReportHist.FINDSET THEN
                REPEAT
                    TempLineFeeNoteOnReportHist.INIT;
                    TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.INSERT;
                UNTIL LineFeeNoteOnReportHist.NEXT = 0;
        END;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitialize(var NoCopies: Integer; var PrintCompany: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure SSI_Update_BillTo_ShipTo_Address(var BillToAddr: array[8] of Text[100]; var ShipToAddr: array[8] of Text[100]; var SalesInvHeader: Record "Sales Invoice Header")
    begin
    end;
}
