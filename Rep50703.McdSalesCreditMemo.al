report 50703 "Mcd Sales Credit Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/layout/McdSalesCreditMemo.rdl';
    Caption = 'SSI Sales Credit Memo';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Credit Memo';

            column(No_SalesCrMemoHeader; "No.")
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No."=FIELD("Document No."), "Document Line No."=FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")WHERE("Document Type"=CONST("Posted Credit Memo"), "Print On Credit Memo"=CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempLine(Comment, 10);
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    TempSalesCrMemoLine:="Sales Cr.Memo Line";
                    TempSalesCrMemoLine.INSERT;
                    HighestLineNo:="Line No.";
                end;
                trigger OnPreDataItem()
                begin
                    TempSalesCrMemoLine.RESET;
                    TempSalesCrMemoLine.DELETEALL;
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")WHERE("Document Type"=CONST("Posted Credit Memo"), "Print On Credit Memo"=CONST(true), "Document Line No."=CONST(0));

                trigger OnAfterGetRecord()
                begin
                    j+=1;
                    InsertTempLine(Comment, 1000);
                end;
                trigger OnPostDataItem()
                begin
                    IF j > 1 THEN InsertTempLine('', 1000);
                end;
                trigger OnPreDataItem()
                begin
                    WITH TempSalesCrMemoLine DO BEGIN
                        INIT;
                        "Document No.":="Sales Cr.Memo Header"."No.";
                        "Line No.":=HighestLineNo + 1000;
                        HighestLineNo:="Line No.";
                    END;
                    TempSalesCrMemoLine.INSERT;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)WHERE(Number=CONST(1));

                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
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
                    column(ShptDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Shipment Date")
                    {
                    }
                    column(ApplDocType_SalesCrMemoHeader; "Sales Cr.Memo Header"."Applies-to Doc. Type")
                    {
                    }
                    column(ApplDocNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Applies-to Doc. No.")
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
                    column(BilltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."External Document No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(DocDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Document Date")
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
                    column(TaxIdentType_Cust; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(CreditCaption; CreditCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(ApplytoTypeCaption; ApplytoTypeCaptionLbl)
                    {
                    }
                    column(ApplytoNumberCaption; ApplytoNumberCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(CreditMemoCaption; CreditMemoCaptionLbl)
                    {
                    }
                    column(CreditMemoNumberCaption; CreditMemoNumberCaptionLbl)
                    {
                    }
                    column(CreditMemoDateCaption; CreditMemoDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    dataitem(SalesCrMemoLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);

                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLineNo; TempSalesCrMemoLine."No.")
                        {
                        }
                        column(TempSalesCrMemoLineUOM; TempSalesCrMemoLine."Unit of Measure")
                        {
                        }
                        column(TempSalesCrMemoLineQty; TempSalesCrMemoLine.Quantity)
                        {
                        DecimalPlaces = 0: 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                        DecimalPlaces = 2: 5;
                        }
                        column(TempSalesCrMemoLineDesc; TempSalesCrMemoLine.Description + ' ' + TempSalesCrMemoLine."Description 2")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesCrMemoLineAmtTaxLiable; TempSalesCrMemoLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesCrMemoLineAmtAmtExclInvDisc; TempSalesCrMemoLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLineAmtInclVATAmt; TempSalesCrMemoLine."Amount Including VAT" - TempSalesCrMemoLine.Amount)
                        {
                        }
                        column(TempSalesCrMemoLineAmtInclVAT; TempSalesCrMemoLine."Amount Including VAT")
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
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaptionLbl)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaptionLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber:=OnLineNumber + 1;
                            WITH TempSalesCrMemoLine DO BEGIN
                                IF OnLineNumber = 1 THEN FIND('-')
                                ELSE
                                    NEXT;
                                IF Type = 0 THEN BEGIN
                                    "No.":='';
                                    "Unit of Measure":='';
                                    Amount:=0;
                                    "Amount Including VAT":=0;
                                    "Inv. Discount Amount":=0;
                                    Quantity:=0;
                                END
                                ELSE IF Type = Type::"G/L Account" THEN "No.":='';
                                IF Amount <> "Amount Including VAT" THEN TaxLiable:=Amount
                                ELSE
                                    TaxLiable:=0;
                                AmountExclInvDisc:=Amount + "Inv. Discount Amount";
                                IF Quantity = 0 THEN UnitPriceToPrint:=0 // so it won't print
                                ELSE
                                    UnitPriceToPrint:=ROUND(AmountExclInvDisc / Quantity, 0.00001);
                            END;
                            IF OnLineNumber = NumberOfLines THEN PrintFooter:=TRUE;
                        end;
                        trigger OnPreDataItem()
                        begin
                            TempSalesCrMemoLine.RESET;
                            CLEAR(TaxLiable);
                            CLEAR(AmountExclInvDisc);
                            NumberOfLines:=TempSalesCrMemoLine.COUNT;
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
                        IF NOT CurrReport.PREVIEW THEN SalesCrMemoPrinted.RUN("Sales Cr.Memo Header");
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
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                IF PrintCompany THEN IF RespCenter.GET("Responsibility Center")THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                    // CompanyInfo."Phone No." := RespCenter."Phone No.";
                    // CompanyInfo."Fax No." := RespCenter."Fax No.";
                    //END;
                    end;
                IF CompanyAddress[4] = '' THEN BEGIN
                    CompanyAddress[4]:='Phone No.:' + CompanyInfo."Phone No.";
                    CompanyAddress[5]:='E-Mail: ' + CompanyInfo."E-mail";
                END
                ELSE
                BEGIN
                    CompanyAddress[5]:='Phone No.:' + CompanyInfo."Phone No.";
                    CompanyAddress[6]:='E-Mail: ' + CompanyInfo."E-mail";
                END;
                IF "Salesperson Code" = '' THEN CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");
                IF "Bill-to Customer No." = '' THEN BEGIN
                    "Bill-to Name":=Text009;
                    "Ship-to Name":=Text009;
                END;
                j:=0;
                FormatAddress.SalesCrMemoBillTo(BillToAddress, "Sales Cr.Memo Header");
                FormatAddress.SalesCrMemoShipTo(ShipToAddress, ShipToAddress, "Sales Cr.Memo Header");
                IF LogInteraction THEN IF NOT CurrReport.PREVIEW THEN SegManagement.LogDocument(6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code", "Campaign No.", "Posting Description", '');
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
                        TaxRegNo:=CompanyInfo."VAT Registration No.";
                        TaxRegLabel:=CompanyInfo.FIELDCAPTION("VAT Registration No.");
                    END;
                    END;
                    SalesTaxCalc.StartSalesTaxCalculation;
                    IF TaxArea."Use External Tax Engine" THEN SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Cr.Memo Header", 0, "No.")
                    ELSE
                    BEGIN
                        SalesTaxCalc.AddSalesCrMemoLines("No.");
                        SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    END;
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
                SSI_Update_BillTo_ShipTo_Address(BillToAddress, ShipToAddress, "Sales Cr.Memo Header");
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
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable:=TRUE;
            OnAfterInitialize(NoCopies, PrintCompany);
        end;
        trigger OnOpenPage()
        begin
            LogInteraction:=SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';
            LogInteractionEnable:=LogInteraction;
            PrintCompany:=true;
        end;
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        IF PrintCompany THEN FormatAddress.Company(CompanyAddress, CompanyInfo)
        ELSE
            CLEAR(CompanyAddress);
    end;
    Protected var j: Integer;
    TaxLiable: Decimal;
    UnitPriceToPrint: Decimal;
    AmountExclInvDisc: Decimal;
    SalesPurchPerson: Record "Salesperson/Purchaser";
    CompanyInfo: Record "Company Information";
    CompanyInfo1: Record "Company Information";
    CompanyInfo3: Record "Company Information";
    CompanyInfo2: Record "Company Information";
    SalesSetup: Record "Sales & Receivables Setup";
    TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
    RespCenter: Record "Responsibility Center";
    Language: Record Language;
    TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
    TaxArea: Record "Tax Area";
    Cust: Record Customer;
    SalesCrMemoPrinted: Codeunit "Sales Cr. Memo-Printed";
    FormatAddress: Codeunit "Format Address";
    FormatDocument: Codeunit "Format Document";
    SalesTaxCalc: Codeunit "Sales Tax Calculate";
    SegManagement: Codeunit SegManagement;
    CompanyAddress: array[8]of Text[100];
    BillToAddress: array[8]of Text[100];
    ShipToAddress: array[8]of Text[100];
    CopyTxt: Text;
    PrintCompany: Boolean;
    PrintFooter: Boolean;
    NoCopies: Integer;
    NoLoops: Integer;
    CopyNo: Integer;
    NumberOfLines: Integer;
    OnLineNumber: Integer;
    HighestLineNo: Integer;
    SpacePointer: Integer;
    LogInteraction: Boolean;
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
    Text003: Label 'Sales Tax Breakdown:';
    Text004: Label 'Other Taxes';
    Text005: Label 'Total Sales Tax:';
    Text006: Label 'Tax Breakdown:';
    Text007: Label 'Total Tax:';
    Text008: Label 'Tax:';
    Text009: Label 'VOID CREDIT MEMO';
    [InDataSet]
    LogInteractionEnable: Boolean;
    CreditCaptionLbl: Label 'CREDIT';
    ShipDateCaptionLbl: Label 'SHIP DATE';
    ApplytoTypeCaptionLbl: Label 'APPLY TO TYPE';
    ApplytoNumberCaptionLbl: Label 'APPLY TO NO.';
    CustomerIDCaptionLbl: Label 'CUSTOMER NO.';
    PONumberCaptionLbl: Label 'P.O. NO.';
    SalesPersonCaptionLbl: Label 'SALESPERSON';
    ShipCaptionLbl: Label 'Ship';
    CreditMemoCaptionLbl: Label 'CREDIT MEMO';
    CreditMemoNumberCaptionLbl: Label 'CREDIT MEMO NUMBER';
    CreditMemoDateCaptionLbl: Label 'CREDIT MEMO DATE';
    PageCaptionLbl: Label 'Page:';
    TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
    ToCaptionLbl: Label 'To:';
    ItemNoCaptionLbl: Label 'Item No.';
    UnitCaptionLbl: Label 'Unit';
    DescriptionCaptionLbl: Label 'Description';
    QuantityCaptionLbl: Label 'Quantity';
    UnitPriceCaptionLbl: Label 'Unit Price';
    TotalPriceCaptionLbl: Label 'Total Price';
    SubtotalCaptionLbl: Label 'Subtotal:';
    InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
    TotalCaptionLbl: Label 'Total:';
    AmountSubjecttoSalesTaxCaptionLbl: Label 'Amount Subject to Sales Tax';
    AmountExemptfromSalesTaxCaptionLbl: Label 'Amount Exempt from Sales Tax';
    local procedure InsertTempLine(Comment: Text[80]; IncrNo: Integer)
    begin
        WITH TempSalesCrMemoLine DO BEGIN
            INIT;
            "Document No.":="Sales Cr.Memo Header"."No.";
            "Line No.":=HighestLineNo + IncrNo;
            HighestLineNo:="Line No.";
        END;
        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesCrMemoLine.Description)THEN BEGIN
            TempSalesCrMemoLine.Description:=COPYSTR(Comment, 1, MAXSTRLEN(TempSalesCrMemoLine.Description));
            TempSalesCrMemoLine."Description 2":='';
        END
        ELSE
        BEGIN
            SpacePointer:=MAXSTRLEN(TempSalesCrMemoLine.Description) + 1;
            WHILE(SpacePointer > 1) AND (Comment[SpacePointer] <> ' ')DO SpacePointer:=SpacePointer - 1;
            IF SpacePointer = 1 THEN SpacePointer:=MAXSTRLEN(TempSalesCrMemoLine.Description) + 1;
            TempSalesCrMemoLine.Description:=COPYSTR(Comment, 1, SpacePointer - 1);
            TempSalesCrMemoLine."Description 2":=COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesCrMemoLine."Description 2"));
        END;
        IF j = 1 THEN TempSalesCrMemoLine.Description:='CM Comments: ' + TempSalesCrMemoLine.Description;
        TempSalesCrMemoLine.INSERT;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterInitialize(var NoCopies: Integer; var PrintCompany: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure SSI_Update_BillTo_ShipTo_Address(var BillToAddr: array[8]of Text[100]; var ShipToAddr: array[8]of Text[100]; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;
}
