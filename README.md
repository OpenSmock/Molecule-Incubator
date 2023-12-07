[![License](https://img.shields.io/github/license/OpenSmock/Molecule-Incubator.svg)](./LICENSE)
[![Pharo 11 CI](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo12CI.yml)

# Molecule Incubator

Molecule component framework tools and features incubation project.

Molecule UI tools experimentation zone.

UI Tools are coming in next versions of Molecule. 
They are currently in development in incubators packages, are ready to use but may be instable.

![image](https://user-images.githubusercontent.com/49183340/151664721-feefb39a-6a9f-44b8-a54d-ef4f2b01bc65.png)
![moleculeUITools](https://user-images.githubusercontent.com/49183340/120898493-5eb8e100-c62b-11eb-86c6-021dc25e5dd0.PNG)
![MoleculeIncubator_EditorTest](https://user-images.githubusercontent.com/49183340/152546159-17f15103-2ac7-4938-8d8f-9de8ff60f3a8.gif)

## Getting Started

### Installation

To install the project on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'MoleculeIncubator';
   repository: 'github://OpenSmock/Molecule-Incubator:main/src';
   load.
```

## Dependencies

- [Molecule](https://github.com/OpenSmock/Molecule)
- [Pyramid](https://github.com/OpenSmock/Pyramid)
- [Roassal](https://github.com/pharo-graphics/Roassal)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
