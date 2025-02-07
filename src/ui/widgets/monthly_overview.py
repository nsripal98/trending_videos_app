from kivymd.uix.card import MDCard
from kivy.garden.matplotlib.backend_kivyagg import FigureCanvasKivyAgg
import matplotlib.pyplot as plt

class MonthlyOverview(MDCard):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_chart()
    
    def setup_chart(self):
        fig, ax = plt.subplots()
        
        # Sample data
        dates = ['1/2023', '2/2023', '3/2023', '4/2023']
        values = [1000, 1200, 900, 1500]
        
        # Create line chart
        ax.plot(dates, values, color='#009688', marker='o')
        ax.set_title('Monthly Overview')
        
        # Add chart to card
        self.add_widget(FigureCanvasKivyAgg(fig))