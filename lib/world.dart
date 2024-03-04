import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class World extends StatefulWidget {
  const World({super.key});

  @override
  State<World> createState() => _WorldState();
}

class _WorldState extends State<World> {
  final int row = 100;
  final int col = 100;
  late List<List<bool>> grid;

  final String deadAssetPath = 'assets/dead.svg';
  late final Widget deadSVG;

  final String aliveAssetPath = 'assets/alive.svg';
  late final Widget aliveSVG;

  late List<Widget> svgS;

  @override
  void initState() {
    super.initState();
    grid = List.generate(
      row,
      (index) => List.generate(
        col,
        (index) => Random().nextBool(),
      ),
    );

    deadSVG = SvgPicture.asset(
      deadAssetPath,
      semanticsLabel: 'DeadCell',
    );

    aliveSVG = SvgPicture.asset(
      aliveAssetPath,
      semanticsLabel: 'AliveCell',
    );

    svgS = [];

    grid.asMap().forEach((int rowIndex, List<bool> boolList) {
      boolList.asMap().forEach((int colIndex, value) {
        svgS.add(value ? aliveSVG : deadSVG);
      });
    });

    gameLoop();
  }

  void gameLoop() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      nextGeneration();
      List<Widget> newSvgS = [];

      grid.asMap().forEach((int rowIndex, List<bool> boolList) {
        boolList.asMap().forEach((int colIndex, value) {
          newSvgS.add(value ? aliveSVG : deadSVG);
        });
      });
      svgS = newSvgS;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: col,
      children: svgS,
    );
  }

  void nextGeneration() {
    List<List<bool>> newGrid = List.generate(
      row,
      (index) => List.generate(
        col,
        (index) => false,
      ),
    );

    for (int rowIndex = 0; rowIndex < row; rowIndex++) {
      for (int colIndex = 0; colIndex < col; colIndex++) {
        int aliveNeighbours = countAliveNeighbours(rowIndex, colIndex);
        if (grid[rowIndex][colIndex] &&
            aliveNeighbours >= 2 &&
            aliveNeighbours <= 3) {
          newGrid[rowIndex][colIndex] = true;
        } else if (!grid[rowIndex][colIndex] && aliveNeighbours == 3) {
          newGrid[rowIndex][colIndex] = true;
        }
      }
    }

    grid = newGrid;
  }

  int countAliveNeighbours(rowIndex, colIndex) {
    int numOfAliveNeighbors = 0;
    bool boundingConstraints = colIndex > 0 &&
        rowIndex > 0 &&
        colIndex < (col - 1) &&
        rowIndex < (row - 1);

    // top left
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex - 1][colIndex - 1] ? 1 : 0;

    // top center
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex - 1][colIndex] ? 1 : 0;

    // top right
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex - 1][colIndex + 1] ? 1 : 0;

    // left
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex][colIndex - 1] ? 1 : 0;

    // right
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex][colIndex + 1] ? 1 : 0;

    // bottom left
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex + 1][colIndex - 1] ? 1 : 0;

    // bottom center
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex + 1][colIndex] ? 1 : 0;

    // bottom right
    numOfAliveNeighbors +=
        boundingConstraints && grid[rowIndex + 1][colIndex + 1] ? 1 : 0;

    return numOfAliveNeighbors;
  }
}
