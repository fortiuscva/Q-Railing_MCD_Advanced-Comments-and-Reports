report 50704 "Mcd Sales Quote"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/McdSalesQuote.rdl';
    Caption = 'SSI Sales - Quote';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")WHERE("Document Type"=CONST(Quote));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Order';

            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")WHERE("Document Type"=CONST(Quote));

                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No."=FIELD("Document No."), "Document Line No."=FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")WHERE("Document Type"=CONST(Quote), "Print On Quote"=CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        WITH TempSalesLine DO BEGIN
                            INIT;
                            "Document Type":="Sales Header"."Document Type";
                            "Document No.":="Sales Header"."No.";
                            "Line No.":=HighestLineNo + 10;
                            HighestLineNo:="Line No.";
                        END;
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description)THEN BEGIN
                            TempSalesLine.Description:=Comment;
                            TempSalesLine."Description 2":='';
                        END
                        ELSE
                        BEGIN
                            SpacePointer:=MAXSTRLEN(TempSalesLine.Description) + 1;
                            WHILE(SpacePointer > 1) AND (Comment[SpacePointer] <> ' ')DO SpacePointer:=SpacePointer - 1;
                            IF SpacePointer = 1 THEN SpacePointer:=MAXSTRLEN(TempSalesLine.Description) + 1;
                            TempSalesLine.Description:=COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesLine."Description 2":=COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                        END;
                        TempSalesLine.INSERT;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    TempSalesLine:="Sales Line";
                    TempSalesLine.INSERT;
                    TempSalesLineAsm:="Sales Line";
                    TempSalesLineAsm.INSERT;
                    HighestLineNo:="Line No.";
                    IF("Sales Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN SalesTaxCalc.AddSalesLine(TempSalesLine);
                end;
                trigger OnPostDataItem()
                begin
                    IF "Sales Header"."Tax Area Code" <> '' THEN BEGIN
                        IF UseExternalTaxEngine THEN SalesTaxCalc.CallExternalTaxEngineForSales("Sales Header", TRUE)
                        ELSE
                            SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                        SalesTaxCalc.DistTaxOverSalesLines(TempSalesLine);
                        SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                        BrkIdx:=0;
                        PrevPrintOrder:=0;
                        PrevTaxPercent:=0;
                        WITH TempSalesTaxAmtLine DO BEGIN
                            RESET;
                            SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                            IF FIND('-')THEN REPEAT IF("Print Order" = 0) OR ("Print Order" <> PrevPrintOrder) OR ("Tax %" <> PrevTaxPercent)THEN BEGIN
                                        BrkIdx:=BrkIdx + 1;
                                        IF BrkIdx > 1 THEN BEGIN
                                            IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN BreakdownTitle:=Text006
                                            ELSE
                                                BreakdownTitle:=Text003;
                                        END;
                                        IF BrkIdx > ARRAYLEN(BreakdownAmt)THEN BEGIN
                                            BrkIdx:=BrkIdx - 1;
                                            BreakdownLabel[BrkIdx]:=Text004;
                                        END
                                        ELSE
                                            BreakdownLabel[BrkIdx]:=STRSUBSTNO("Print Description", "Tax %");
                                    END;
                                    BreakdownAmt[BrkIdx]:=BreakdownAmt[BrkIdx] + "Tax Amount";
                                UNTIL NEXT = 0;
                        END;
                        IF BrkIdx = 1 THEN BEGIN
                            CLEAR(BreakdownLabel);
                            CLEAR(BreakdownAmt);
                        END;
                    END;
                end;
                trigger OnPreDataItem()
                begin
                    TempSalesLine.RESET;
                    TempSalesLine.DELETEALL;
                    TempSalesLineAsm.RESET;
                    TempSalesLineAsm.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")WHERE("Document Type"=CONST(Quote), "Print On Quote"=CONST(True), "Document Line No."=CONST(0));

                trigger OnAfterGetRecord()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type":="Sales Header"."Document Type";
                        "Document No.":="Sales Header"."No.";
                        "Line No.":=HighestLineNo + 1000;
                        HighestLineNo:="Line No.";
                    END;
                    j+=1;
                    IF STRLEN(Comment) <= MAXSTRLEN(TempSalesLine.Description)THEN BEGIN
                        IF j = 1 THEN TempSalesLine.Description:='Quote Comments: ' + Comment
                        ELSE
                            TempSalesLine.Description:=Comment;
                        TempSalesLine."Description 2":='';
                    END
                    ELSE
                    BEGIN
                        SpacePointer:=MAXSTRLEN(TempSalesLine.Description) + 1;
                        WHILE(SpacePointer > 1) AND (Comment[SpacePointer] <> ' ')DO SpacePointer:=SpacePointer - 1;
                        IF SpacePointer = 1 THEN SpacePointer:=MAXSTRLEN(TempSalesLine.Description) + 1;
                        TempSalesLine.Description:=COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesLine."Description 2":=COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesLine."Description 2"));
                    END;
                    TempSalesLine.INSERT;
                end;
                trigger OnPreDataItem()
                begin
                    WITH TempSalesLine DO BEGIN
                        INIT;
                        "Document Type":="Sales Header"."Document Type";
                        "Document No.":="Sales Header"."No.";
                        "Line No.":=HighestLineNo + 1000;
                        HighestLineNo:="Line No.";
                    END;
                    TempSalesLine.INSERT;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));

                    column(VALIDDATE; "Sales Header"."Quote Valid Until Date")
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo3.Picture)
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
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Header"."Order Date")
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
                    column(ShipmentMethodDesc; "Sales Header"."Shipping Agent Code")
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(PrintFooter; PrintFooter)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(SellCaption; SellCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(SalesQuoteCaption; SalesQuoteCaptionLbl)
                    {
                    }
                    column(SalesQuoteNumberCaption; SalesQuoteNumberCaptionLbl)
                    {
                    }
                    column(SalesQuoteDateCaption; SalesQuoteDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(YourRef; "Sales Header"."Your Reference")
                    {
                    }
                    column(ShippingNote; "sales Header".McdShippingNote)
                    {
                    }
                    dataitem(SalesLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);

                        column(Number_IntegerLine; Number)
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesLineNo; TempSalesLine."No.")
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(TempSalesLineUOM; TempSalesLine."Unit of Measure")
                        {
                        }
                        column(TempSalesLineQuantity; TempSalesLine.Quantity)
                        {
                        DecimalPlaces = 0: 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                        DecimalPlaces = 2: 5;
                        }
                        column(LineAmount; TempSalesLine."Line Amount")
                        {
                        }
                        column(TempSalesLineDescription; TempSalesLine.Description + ' ' + TempSalesLine."Description 2")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesLineLineAmtTaxLiable; TempSalesLine."Line Amount" - TaxLiable)
                        {
                        }
                        column(TempSalesLineInvDiscAmt; TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(UnitPrice; TempSalesLine."Unit Price")
                        {
                        }
                        column(TempSalesLineDiscPercent; TempSalesLine."Line Discount %")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(TempSalesLineLineAmtTaxAmtInvDiscAmt; TempSalesLine."Line Amount" + TaxAmount - TempSalesLine."Inv. Discount Amount")
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
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
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(AmtSubjecttoSalesTaxCptn; AmtSubjecttoSalesTaxCptnLbl)
                        {
                        }
                        column(AmtExemptfromSalesTaxCptn; AmtExemptfromSalesTaxCptnLbl)
                        {
                        }
                        column(ItemPicture; TenantMedia.Content)
                        {
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number);

                            column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            {
                            }
                            column(AsmLineDescription; AsmLine.Description)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent + AsmLine."No.")
                            {
                            }
                            column(AsmLineType; AsmLine.Type)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN AsmLine.FINDSET
                                ELSE
                                BEGIN
                                    AsmLine.NEXT;
                                    TaxLiable:=0;
                                    TaxAmount:=0;
                                    AmountExclInvDisc:=0;
                                    TempSalesLine."Line Amount":=0;
                                    TempSalesLine."Inv. Discount Amount":=0;
                                END;
                            end;
                            trigger OnPreDataItem()
                            begin
                                IF NOT DisplayAssemblyInformation THEN CurrReport.BREAK;
                                IF NOT AsmInfoExistsForLine THEN CurrReport.BREAK;
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        var
                            SalesLine: Record "Sales Line";
                        begin
                            OnLineNumber:=OnLineNumber + 1;
                            Clear(Item);
                            clear(TenantMedia);
                            WITH TempSalesLine DO BEGIN
                                IF OnLineNumber = 1 THEN FIND('-')
                                ELSE
                                    NEXT;
                                //>>Mcd
                                if type = Type::Item then if item.get("No.")then if item.Picture.Count > 0 then begin
                                            TenantMedia.Get(item.Picture.Item(1));
                                            TenantMedia.CalcFields(Content);
                                        end;
                                //<<Mcd
                                IF Type = 0 THEN BEGIN
                                    "No.":='';
                                    "Unit of Measure":='';
                                    "Line Amount":=0;
                                    "Inv. Discount Amount":=0;
                                    Quantity:=0;
                                END; // ELSE
                                //   IF Type = Type::"G/L Account" THEN
                                //      "No." := '';
                                IF "Tax Area Code" <> '' THEN TaxAmount:="Amount Including VAT" - Amount
                                ELSE
                                    TaxAmount:=0;
                                IF TaxAmount <> 0 THEN TaxLiable:=Amount
                                ELSE
                                    TaxLiable:=0;
                                OnAfterCalculateSalesTax("Sales Header", TempSalesLine, TaxAmount, TaxLiable);
                                AmountExclInvDisc:="Line Amount";
                                IF Quantity = 0 THEN UnitPriceToPrint:=0 // so it won't print
                                ELSE
                                    UnitPriceToPrint:=ROUND(AmountExclInvDisc / Quantity, 0.00001);
                                IF DisplayAssemblyInformation THEN BEGIN
                                    AsmInfoExistsForLine:=FALSE;
                                    IF TempSalesLineAsm.GET("Document Type", "Document No.", "Line No.")THEN BEGIN
                                        SalesLine.GET("Document Type", "Document No.", "Line No.");
                                        AsmInfoExistsForLine:=SalesLine.AsmToOrderExists(AsmHeader);
                                    END;
                                END;
                            END;
                            IF OnLineNumber = NumberOfLines THEN PrintFooter:=TRUE;
                        end;
                        trigger OnPreDataItem()
                        begin
                            CLEAR(TaxLiable);
                            CLEAR(TaxAmount);
                            CLEAR(AmountExclInvDisc);
                            tempsalesline.reset;
                            NumberOfLines:=TempSalesLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber:=0;
                            PrintFooter:=FALSE;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    CurrReport.PAGENO:=1;
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN SalesPrinted.RUN("Sales Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo:=CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
 CLEAR(CopyTxt)
                    ELSE
                        CopyTxt:=Text000;
                end;
                trigger OnPreDataItem()
                begin
                    NoLoops:=1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN NoLoops:=1;
                    CopyNo:=0;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                IF PrintCompany THEN IF RespCenter.GET("Responsibility Center")THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                    //   CompanyInformation."Phone No." := RespCenter."Phone No.";
                    //   CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                j:=0;
                FormatDocumentFields("Sales Header");
                IF CompanyAddress[4] = '' THEN BEGIN
                    CompanyAddress[4]:='Phone No.:' + CompanyInformation."Phone No.";
                    CompanyAddress[5]:='E-Mail: ' + CompanyInformation."E-mail";
                END
                ELSE
                BEGIN
                    CompanyAddress[5]:='Phone No.:' + CompanyInformation."Phone No.";
                    CompanyAddress[6]:='E-Mail: ' + CompanyInformation."E-mail";
                END;
                IF NOT Cust.GET("Sell-to Customer No.")THEN CLEAR(Cust);
                FormatAddress.SalesHeaderSellTo(BillToAddress, "Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress, ShipToAddress, "Sales Header");
                IF NOT CurrReport.PREVIEW THEN BEGIN
                    IF ArchiveDocument THEN ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);
                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        IF "Bill-to Contact No." <> '' THEN SegManagement.LogDocument(1, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.")
                        ELSE
                            SegManagement.LogDocument(1, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.");
                    END;
                END;
                CLEAR(BreakdownTitle);
                CLEAR(BreakdownLabel);
                CLEAR(BreakdownAmt);
                TotalTaxLabel:=Text008;
                TaxRegNo:='';
                TaxRegLabel:='';
                IF "Tax Area Code" <> '' THEN BEGIN
                    TaxArea.GET("Tax Area Code");
                    CASE TaxArea."Country/Region" OF TaxArea."Country/Region"::US: TotalTaxLabel:=Text005;
                    TaxArea."Country/Region"::CA: BEGIN
                        TotalTaxLabel:=Text007;
                        TaxRegNo:=CompanyInformation."VAT Registration No.";
                        TaxRegLabel:=CompanyInformation.FIELDCAPTION("VAT Registration No.");
                    END;
                    END;
                    UseExternalTaxEngine:=TaxArea."Use External Tax Engine";
                    SalesTaxCalc.StartSalesTaxCalculation;
                END;
                UseDate:=WORKDATE;
                SSI_Update_BillTo_ShipTo_Address(BillToAddress, ShipToAddress, "Sales Header");
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
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';

                        trigger OnValidate()
                        begin
                            IF NOT ArchiveDocument THEN LogInteraction:=FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';

                        trigger OnValidate()
                        begin
                            IF LogInteraction THEN ArchiveDocument:=ArchiveDocumentEnable;
                        end;
                    }
                    field("Display Assembly information"; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable:=TRUE;
            ArchiveDocumentEnable:=TRUE;
        end;
        trigger OnOpenPage()
        begin
            ArchiveDocument:=(SalesSetup."Archive Quotes" = SalesSetup."Archive Quotes"::Question) OR (SalesSetup."Archive Quotes" = SalesSetup."Archive Quotes"::Always);
            LogInteraction:=SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Qte.") <> '';
            ArchiveDocumentEnable:=ArchiveDocument;
            LogInteractionEnable:=LogInteraction;
            PrintCompany:=true;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInformation.GET;
        OnAfterInitialize(NoCopies, PrintCompany);
    end;
    trigger OnPreReport()
    begin
        IF PrintCompany THEN FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;
    Protected var j: Integer;
    TaxLiable: Decimal;
    UnitPriceToPrint: Decimal;
    AmountExclInvDisc: Decimal;
    ShipmentMethod: Record "Shipment Method";
    PaymentTerms: Record "Payment Terms";
    SalesPurchPerson: Record "Salesperson/Purchaser";
    CompanyInformation: Record "Company Information";
    CompanyInfo1: Record "Company Information";
    CompanyInfo2: Record "Company Information";
    CompanyInfo3: Record "Company Information";
    CompanyInfo: Record "Company Information";
    SalesSetup: Record "Sales & Receivables Setup";
    TempSalesLine: Record "Sales Line" temporary;
    TempSalesLineAsm: Record "Sales Line" temporary;
    RespCenter: Record "Responsibility Center";
    Language: Record Language;
    TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    TaxArea: Record "Tax Area";
    Cust: Record Customer;
    SalesPrinted: Codeunit "Sales-Printed";
    FormatAddress: Codeunit "Format Address";
    FormatDocument: Codeunit "Format Document";
    SalesTaxCalc: Codeunit "Sales Tax Calculate";
    ArchiveManagement: Codeunit ArchiveManagement;
    SegManagement: Codeunit SegManagement;
    CompanyAddress: array[8]of Text[100];
    BillToAddress: array[8]of Text[100];
    ShipToAddress: array[8]of Text[100];
    CopyTxt: Text;
    SalespersonText: Text[50];
    PrintCompany: Boolean;
    PrintFooter: Boolean;
    NoCopies: Integer;
    NoLoops: Integer;
    CopyNo: Integer;
    NumberOfLines: Integer;
    OnLineNumber: Integer;
    HighestLineNo: Integer;
    SpacePointer: Integer;
    TaxAmount: Decimal;
    ArchiveDocument: Boolean;
    LogInteraction: Boolean;
    DisplayAssemblyInformation: Boolean;
    Text000: Label 'COPY';
    TaxRegNo: Text;
    TaxRegLabel: Text;
    TotalTaxLabel: Text;
    BreakdownTitle: Text;
    BreakdownLabel: array[4]of Text;
    BreakdownAmt: array[4]of Decimal;
    BrkIdx: Integer;
    PrevPrintOrder: Integer;
    PrevTaxPercent: Decimal;
    UseDate: Date;
    Text003: Label 'Sales Tax Breakdown:';
    Text004: Label 'Other Taxes';
    Text005: Label 'Total Sales Tax:';
    Text006: Label 'Tax Breakdown:';
    Text007: Label 'Total Tax:';
    Text008: Label 'Tax:';
    UseExternalTaxEngine: Boolean;
    [InDataSet]
    ArchiveDocumentEnable: Boolean;
    [InDataSet]
    LogInteractionEnable: Boolean;
    SellCaptionLbl: Label 'Sell';
    ToCaptionLbl: Label 'To:';
    CustomerIDCaptionLbl: Label 'CUSTOMER NO.';
    SalesPersonCaptionLbl: Label 'SALESPERSON';
    ShipCaptionLbl: Label 'Ship';
    SalesQuoteCaptionLbl: Label 'SALES QUOTE';
    SalesQuoteNumberCaptionLbl: Label 'SALES QUOTE NUMBER';
    SalesQuoteDateCaptionLbl: Label 'SALES QUOTE DATE';
    PageCaptionLbl: Label 'Page:';
    ShipViaCaptionLbl: Label 'SHIP VIA';
    TermsCaptionLbl: Label 'TERMS';
    TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
    ItemNoCaptionLbl: Label 'Item No.';
    UnitCaptionLbl: Label 'Unit';
    DescriptionCaptionLbl: Label 'Description';
    QuantityCaptionLbl: Label 'Quantity';
    UnitPriceCaptionLbl: Label 'Unit Price';
    TotalPriceCaptionLbl: Label 'Total Price';
    SubtotalCaptionLbl: Label 'Subtotal:';
    InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
    TotalCaptionLbl: Label 'Total:';
    AmtSubjecttoSalesTaxCptnLbl: Label 'Amount Subject to Sales Tax';
    AmtExemptfromSalesTaxCptnLbl: Label 'Amount Exempt from Sales Tax';
    AsmLine: Record "Assembly Line";
    AsmInfoExistsForLine: Boolean;
    AsmHeader: Record "Assembly Header";
    Item: Record item;
    TenantMedia: Record "Tenant Media";
    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode)THEN EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;
    procedure BlanksForIndent(): Text[10]begin
        EXIT(PADSTR('', 2, ' '));
    end;
    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        WITH SalesHeader DO BEGIN
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalespersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
        END;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateSalesTax(var SalesHeaderParm: Record "Sales Header"; var SalesLineParm: Record "Sales Line"; var TaxAmount: Decimal; var TaxLiable: Decimal)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterInitialize(var NoCopies: Integer; var PrintCompany: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure SSI_Update_BillTo_ShipTo_Address(var BillToAddr: array[8]of Text[100]; var ShipToAddr: array[8]of Text[100]; var SalesHeader: Record "Sales Header")
    begin
    end;
}
