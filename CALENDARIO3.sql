SET DATEFIRST 7

Declare @Calendario Table (Idx Int Identity(1,1) , Segunda Int Default 0 , Terça Int Default 0,  Quarta Int Default 0 , Quinta Int Default 0 , 
                           Sexta Int Default 0 , Sabado Int Default 0 , Domingo Int Default 0)

Declare @MonthStart Datetime
Declare @MonthEnd  Datetime
Declare @Idx  Int

set nocount on

Select @MonthStart = '2019-08-01' , @MonthEnd = '2019-09-30', @Idx = 1

While @MonthStart <= @MonthEnd
Begin 
  Insert into @Calendario Default Values
  While 1=1
     Begin  
       Update @Calendario 
       Set Segunda = Case When DatePart(WeekDay,@MonthStart) = 2 Then   DatePart(Day,@MonthStart) Else Segunda End,
           Terça   = Case When DatePart(WeekDay,@MonthStart) = 3 Then   DatePart(Day,@MonthStart) Else Terça End,
           Quarta  = Case When DatePart(WeekDay,@MonthStart) = 4 Then   DatePart(Day,@MonthStart) Else Quarta End,
           Quinta  = Case When DatePart(WeekDay,@MonthStart) = 5 Then   DatePart(Day,@MonthStart) Else Quinta End,
           Sexta   = Case When DatePart(WeekDay,@MonthStart) = 6 Then   DatePart(Day,@MonthStart) Else Sexta End,
           Sabado  = Case When DatePart(WeekDay,@MonthStart) = 7 Then   DatePart(Day,@MonthStart) Else Sabado End,
           Domingo = Case When DatePart(WeekDay,@MonthStart) = 1 Then   DatePart(Day,@MonthStart) Else Domingo End
       Where Idx = @Idx And DatePart(Month,@MonthStart) =  DatePart(Month,@MonthEnd)
   
     --  Select DatePart(WeekDay,@MonthStart)
      If DatePart(WeekDay,@MonthStart) = 1 
           Break
       Select @MonthStart = Dateadd(Day,1,@MonthStart)

     End 
     Select @MonthStart = Dateadd(Day,1,@MonthStart), @Idx = @Idx + 1
End

Select * From @Calendario