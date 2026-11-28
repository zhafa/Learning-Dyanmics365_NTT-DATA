permissionset 50200 EquipmentAdmin_ZH
{
    Assignable = true;
    Caption = 'Equipment Loan - Admin';

    Permissions =
        tabledata Equipment_ZH = RIMD,
        tabledata EquipmentSetup_ZH = RIMD,
        table Equipment_ZH = X,
        table EquipmentSetup_ZH = X,
        page EquipmentList_ZH = X,
        page EquipmentCard_ZH = X,
        page EquipmentSetup_ZH = X,
        codeunit LoanEventSubscribers_ZH = X,
        tabledata Employee = R,
        tabledata "No. Series" = R,
        tabledata "No. Series Line" = RM,
        tabledata LoanHeader_ZH = RIMD,
        tabledata LoanLine_ZH = RIMD,
        table LoanHeader_ZH = X,
        table LoanLine_ZH = X,
        page LoanCard_ZH = X,
        page LoanSubforms_ZH = X,
        page LoanList_ZH = X,
        tabledata Dimension = R,
        tabledata "Dimension Value" = R,
        tabledata "Default Dimension" = R,
        tabledata "General Ledger Setup" = R,
        tabledata "Dimension Set Entry" = RIM,
        tabledata "Dimension Set Tree Node" = RIM,
        tabledata PostedLoanHeader_ZH = RI,
        tabledata PostedLoanLine_ZH = RI,
        table PostedLoanHeader_ZH = X,
        table PostedLoanLine_ZH = X,
        page PostedLoanList_ZH = X,
        page PostedLoanCard_ZH = X,
        page PostedLoanSubform_ZH = X,
        codeunit LoanArchive_ZH = X;

}
