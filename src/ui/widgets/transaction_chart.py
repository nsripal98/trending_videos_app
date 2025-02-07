from kivy.garden.matplotlib.backend_kivyagg import FigureCanvasKivyAgg
from kivymd.uix.card import MDCard
import matplotlib.pyplot as plt

class TransactionChart(MDCard):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.setup_chart()
    
    def setup_chart(self):
        fig, ax = plt.subplots()
        
        # Sample data
        months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
        values = [10, 15, 13, 18, 20, 25]
        
        # Create bar chart
        ax.bar(months, values, color='#009688')
        ax.set_title('Transaction History')
        
        # Add chart to card
        self.add_widget(FigureCanvasKivyAgg(fig))