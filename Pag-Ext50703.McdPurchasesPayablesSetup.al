pageextension 50703 McdPurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group("Purchase Order Comments")
            {
                group(G1)
                {
                    ShowCaption = false;

                    grid(Row1)
                    {
                        GridLayout = Rows;
                        ShowCaption = false;

                        group("Purchase Order Comment Lines")
                        {
                            ShowCaption = false;

                            field("Comment 1";'Purchase Order Comment 1')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 1"; rec."Purch Order Comment 1")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 2";'Purchase Order Comment 2')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 2"; rec."Purch Order Comment 2")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 3";'Purchase Order Comment 3')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 3"; rec."Purch Order Comment 3")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 4";'Purchase Order Comment 4')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 4"; rec."Purch Order Comment 4")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 5";'Purchase Order Comment 5')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 5"; rec."Purch Order Comment 5")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 6";'Purchase Order Comment 6')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 6"; rec."Purch Order Comment 6")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 7";'Purchase Order Comment 7')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 7"; rec."Purch Order Comment 7")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 8";'Purchase Order Comment 8')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 8"; rec."Purch Order Comment 8")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Comment 9";'Purchase Order Comment 9')
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                            field("Purch Order Comment 9"; rec."Purch Order Comment 9")
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                ColumnSpan = 2;
                            }
                        }
                    }
                // grid(Row2)
                // {
                //     GridLayout = Rows;
                //     ShowCaption = false;
                //     group("Purchase Order Comment 2")
                //     {
                //     }
                // }
                }
            }
        }
    }
    var myInt: Integer;
}
