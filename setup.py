from setuptools import setup, find_packages

setup(
    name='trendingvideos',
    version='1.0',
    packages=find_packages(),
    install_requires=[
        'kivy==2.1.0',
        'kivymd==1.1.1',
        'pillow',
        'requests',
        'google-api-python-client',
        'google-auth-httplib2',
        'google-auth-oauthlib',
        'beautifulsoup4',
        'python-dotenv'
    ],
    entry_points={
        'console_scripts': [
            'trendingvideos=main:main',
        ],
    },
)