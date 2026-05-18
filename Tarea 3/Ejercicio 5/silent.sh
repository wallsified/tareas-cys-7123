#!/bin/bash
jp2a  --colors mao-shi.jpg --html --html-title="Flag4"  --output=index.html 

sed -i '/<\/body>/i <div style="color: transparent;">FLAG{s73g4n0gr4phy_15_h1dd3n}</div>' index.html


xdg-open index.html

