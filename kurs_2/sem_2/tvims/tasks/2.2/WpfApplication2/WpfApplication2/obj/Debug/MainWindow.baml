   M S B A M L   `   `   `  ����J  FWpfApplication2, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null1clr-namespace:WpfApplication2WpfApplication2  5   	   ?$clr-namespace:WpfApplication2.ModelsWpfApplication2.Models  5   	        WpfApplication2.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   W SOxyPlot.Wpf, Version=2014.1.546.0, Culture=neutral, PublicKeyToken=75e952ba404cdbb0 oxyhttp://oxyplot.org/wpf  5   
   )localclr-namespace:WpfApplication2  5   	   1models$clr-namespace:WpfApplication2.Models  5   	   $��Calibri)�5
   	   $��16(�6     � Title$3  -Плотность распределения��5   	   $	��550��6)   $	��950��66    � DataContext 5      "  WpfApplication2.Models.Model  5   
   .��5      � $��0,0,2,0q�6    � RowDefinitions 5   
   �� 5      �� 5      $��10 �6   6*   �� 5      $��35 �6   6*    � ColumnDefinitions 5   
   �� 5      6!   �� 5      $	��350 �6   6-   .+�5   
     OxyPlot.Wpf.PlotView  -   5        $��	plot_view��5      $��0��6(   $��0��65   $
��Auto��5    7   $
��Auto��6E      Model 6   �� *PlotViewModel+6E     5"   
   -   5        $��plot_view_1��5"      $��1��6*   $��0��67   $
��Auto��5#   9   $
��Auto��6G    6   �� *PlotViewModel_1+6G   �� 5%   
   -   5        $��	list_view��5%      $��0��6$   $��1��61   $��5,10,5,0q�6A   $��3��6S   ��5&      �� *VariationFunction.Points+ �� View 5'      �� 5(      P�5)      �� 5*      $%��Вариационный ряд��6)    �� Width$	 150��6D    �� DisplayMemberBinding 5+   )   �� *X+ �� StringFormat$ {0:0.00000}���� 5,      $-��'Эмпирическая функция��6)   $	 150��6H    5-   )   �� *Y+$ {0:0.00000}��5/      51      ]� 53   
   $��3��6   $��0��6!   .+�54      �� $��5q�6   $��Center=�6#   $��Значение N = ��6>   �� 55      $��5q�6   ��6!   �� *N+	 �� Mode$	 TwoWay=�56      �� 58   
   -   5        $��3��58      $��1��6   $��5q�59      .��69   Посчитать5;      5<      5=      