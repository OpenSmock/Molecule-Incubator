[![License](https://img.shields.io/github/license/OpenSmock/Molecule-Incubator.svg)](./LICENSE)
[![Pharo 11 CI](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo11CI.yml/badge.svg)](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo11CI.yml)
[![Pharo 12 CI](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo12CI.yml/badge.svg)](https://github.com/OpenSmock/Molecule-Incubator/actions/workflows/Pharo12CI.yml)

# Molecule Incubator

Molecule component framework tools and features incubation project.

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
