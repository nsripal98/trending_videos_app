from kivy.garden.matplotlib.backend_kivyagg import FigureCanvasKivyAgg
from matplotlib import pyplot as plt
from kivymd.uix.card import MDCard

class ChartWidget(MDCard):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = "vertical"
        self.padding = "8dp"
        self.setup_chart()
        
    def setup_chart(self):
        self.figure, self.ax = plt.subplots()
        self.canvas = FigureCanvasKivyAgg(self.figure)
        self.add_widget(self.canvas)
        
    def update_pie_chart(self, data):
        self.ax.clear()
        labels = list(data.keys())
        values = list(data.values())
        self.ax.pie(values, labels=labels, autopct='%1.1f%%')
        self.canvas.draw()
        
    def update_bar_chart(self, labels, values):
        self.ax.clear()
        self.ax.bar(labels, values)
        plt.xticks(rotation=45)
        self.canvas.draw()