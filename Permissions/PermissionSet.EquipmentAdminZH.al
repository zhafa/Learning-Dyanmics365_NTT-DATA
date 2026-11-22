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
        tabledata "No. Series" = R,
        tabledata "No. Series Line" = RM,
        tabledata LoanHeader_ZH = RIMD,
        tabledata LoanLine_ZH = RIMD,
        table LoanHeader_ZH = X,
        table LoanLine_ZH = X,
        page LoanCard_ZH = X,
        page LoanSubforms_ZH = X,
        page LoanList_ZH = X;
}
