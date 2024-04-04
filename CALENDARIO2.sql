Set Nocount On

Set DateFirst 7

SET LANGUAGE PORTUGUÍS

Set DateFormat DMY

 

Declare @Calendario Table

 (Semana Int Identity(1,1) ,

  Segunda SmallInt Default null,

  Terca SmallInt Default null, 

  Quarta SmallInt Default null,

  Quinta SmallInt Default null,

   Sexta SmallInt Default null,

   Sabado SmallInt Default Null,

   Domingo SmallInt Default Null)

 

Declare @DataInicial Date

Declare @DataFinal  Date

Declare @Semana  Int

 

Select @DataInicial = '01/08/2019' , @DataFinal = '31/08/2019', @Semana = 1

 

While @DataInicial <= @DataFinal

Begin

  Insert into @Calendario Default Values

 

  While 1=1

     Begin 

       Update @Calendario

        Set Segunda = Case When DatePart(WeekDay,@DataInicial) = 2 Then DatePart(Day,@DataInicial) Else Segunda End,

              Terca = Case When DatePart(WeekDay,@DataInicial) = 3 Then DatePart(Day,@DataInicial) Else Terca End,

              Quarta = Case When DatePart(WeekDay,@DataInicial) = 4 Then DatePart(Day,@DataInicial) Else Quarta End,

              Quinta = Case When DatePart(WeekDay,@DataInicial) = 5 Then DatePart(Day,@DataInicial) Else Quinta End,

              Sexta = Case When DatePart(WeekDay,@DataInicial) = 6 Then DatePart(Day,@DataInicial) Else Sexta End,

              Sabado = Case When DatePart(WeekDay,@DataInicial) = 7 Then DatePart(Day,@DataInicial) Else Sabado End,

              Domingo = Case When DatePart(WeekDay,@DataInicial) = 1 Then DatePart(Day,@DataInicial) Else Domingo End    

       Where Semana = @Semana

       And DatePart(Month,@DataInicial) =  DatePart(Month,@DataFinal)

      If DatePart(WeekDay,@DataInicial) = 1

       Break

         Select @DataInicial = Dateadd(Day,1,@DataInicial)

      End

     Select @DataInicial = Dateadd(Day,1,@DataInicial)

     Set @Semana = @Semana + 1

End

 

Select * From @Calendario