# Symmetric and Asymmetic Development of Bluetooth-Based Indoor Localization Mechanisms

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](https://github.com/oeg-upm/TINTOlib-Documentation/blob/main/LICENSE)
[![Python Version](https://img.shields.io/badge/Python-3.7%20%7C%203.8%20%7C%203.9%20%7C%203.10%20%7C%203.11-blue)](https://pypi.python.org/pypi/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10620393.svg)](https://doi.org/10.5281/zenodo.10620393)


## Citing these works

### An Empirical Study of the Transmission Power Setting for Bluetooth-Based Indoor Localization Mechanisms

**Citing Asymmetric withouth optimization**: If you used assymetric code in your work, please cite the **[Sensors](https://www.mdpi.com/1424-8220/17/6/1318)**:

```bib
@Article{s17061318,
    AUTHOR = {Castillo-Cara, Manuel and Lovón-Melgarejo, Jesús and Bravo-Rocca, Gusseppe and Orozco-Barbosa, Luis and García-Varea, Ismael},
    TITLE = {An Empirical Study of the Transmission Power Setting for Bluetooth-Based Indoor Localization Mechanisms},
    JOURNAL = {Sensors},
    VOLUME = {17},
    YEAR = {2017},
    NUMBER = {6},
    ARTICLE-NUMBER = {1318},
    PubMedID = {28590413},
    ISSN = {1424-8220}
    DOI = {10.3390/s17061318}
}
```

### An analysis of multiple criteria and setups for Bluetooth smartphone-based indoor localization mechanism

And if you use the smartphone data: **[Jounal of Sensors](https://www.hindawi.com/journals/js/2017/1928578/)** 

```bib
@ARTICLE{1928578,
    author={Castillo-Cara, Manuel and Lovón-Melgarejo, Jesús and Bravo-Rocca, Gusseppe and Orozco-Barbosa, Luis and García-Varea, Ismael},
    journal={Journal of Sensors}, 
    title={An analysis of multiple criteria and setups for Bluetooth smartphone-based indoor localization mechanism}, 
    year={2017},
    volume={2017},
    number={1928578},
    pages={22},
    doi={10.1155/2017/1928578}
  }
```


## Abstract

The present papers constitute a seminal contribution to indoor localization utilizing Bluetooth signals and supervised learning algorithms. They elucidate pivotal scientific advancements that solidify research endeavors in this domain. The manuscripts scrutinize several pivotal facets:

Abourt "An Empirical Study of the Transmission Power Setting for Bluetooth-Based Indoor Localization Mechanisms":
- Evaluation of RSSI fingerprinting: The study evaluates the relevance of the RSSI reported by BLE4.0 at different transmit power levels using feature selection techniques. This evaluation highlights the importance of understanding the relationship between transmit power levels and RSSI for accurate indoor location.
- Asymmetric transmit power adjustment: The study introduces the concept of asymmetric transmit power adjustment of BLE4.0 to mitigate the effects of multipath fading. By exploring different transmit power settings for each BLE4.0, the study demonstrates significant improvements in localisation accuracy.
- Effect of transmit power on classification algorithms: The study compares the performance of classification algorithms, namely k-NN and SVM, with different transmit power settings. It shows that appropriate adjustment of the transmit power levels improves the performance of both algorithms, with k-NN showing better results.

Abourt "An analysis of multiple criteria and setups for Bluetooth smartphone-based indoor localization mechanism":
- The text discusses the significance of BLE 4.0 beacons in enabling energy-efficient indoor location mechanisms, despite their sensitivity to signal fading impairments.
- It identifies key metrics for evaluating the performance of supervised learning algorithms in indoor localisation, including mean localisation error, local prediction accuracy and global prediction accuracy, among others.
- This document provides guidelines for improving localisation through system configuration and algorithm parameters. These guidelines cover parameters such as transmit power, BLE 4.0 position and topology, beacon density and spacing, and algorithm-specific parameters.
- The study highlights the significance of optimising transmit power and transmitter location based on the structural characteristics of the environment to enhance localisation accuracy. 
- The study emphasises the significance of taking into account physical infrastructure parameters, such as transmit power levels, number and location of BLE 4.0 devices, and topology, to enhance indoor localisation mechanisms.

## Getting Started
The project has the following folders
- **Analisys**: Includes all code of paper Journal of Sensors.
- **CombinacionResultados**: Includes Python code of the results with different transmission powers using force-brute algorithm.
- **Medidas**: All data using smartphone and raspberri.
- **scriptsMatlab: It includes results obtained with classical machine learning algorithms with asymmetric transmission power. It is used for smartphone data and also for Raspberri Pi data.

## License

This code is available under the **[Apache License 2.0](https://github.com/oeg-upm/TINTOlib-Documentation/blob/main/LICENSE)**.

## Authors
- **[Manuel Castillo-Cara](https://github.com/manwestc)**


## Institutions

<kbd><img src="https://www.uni.edu.pe/images/logos/logo_uni_2016.png" alt="Universidad Nacional de Ingeniería" width="110"></kbd>
<kbd><img src="https://raw.githubusercontent.com/oeg-upm/TINTO/main/assets/logo-oeg.png" alt="Ontology Engineering Group" width="100"></kbd> 
<kbd><img src="https://raw.githubusercontent.com/oeg-upm/TINTO/main/assets/logo-upm.png" alt="Universidad Politécnica de Madrid" width="100"></kbd>
<kbd><img src="https://raw.githubusercontent.com/oeg-upm/TINTO/main/assets/logo-uclm.png" alt="Universidad de Castilla-La Mancha" width="80"></kbd> 
