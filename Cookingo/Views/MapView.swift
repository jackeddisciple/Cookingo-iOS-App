import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: GameViewModel

    private let greenColor = Color(red: 0.180, green: 0.800, blue: 0.443)
    private let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.329)

    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)
            let (path, positions) = PathHelper.createMapPath(in: rect)

            ZStack {
                // MARK: - Layer 1: Location Decorations (behind path)
                ForEach(Array(viewModel.nodes.enumerated()), id: \.element.id) { index, node in
                    if index < positions.count {
                        locationDecoration(for: node, at: positions[index], index: index)
                    }
                }

                // MARK: - Layer 2: Path
                // Incomplete path
                path.stroke(
                    Color.gray.opacity(0.12),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round)
                )

                // Completed glow
                path.trimmedPath(from: 0, to: viewModel.pathProgress)
                    .stroke(
                        greenColor.opacity(0.20),
                        style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round)
                    )
                    .blur(radius: 8)

                // Completed solid
                path.trimmedPath(from: 0, to: viewModel.pathProgress)
                    .stroke(
                        LinearGradient(
                            colors: [greenColor, greenColor.opacity(0.85)],
                            startPoint: .bottom,
                            endPoint: .top
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round)
                    )

                // Dashed overlay
                path.stroke(
                    Color.white.opacity(0.20),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [8, 12])
                )

                // MARK: - Layer 3: Nodes
                ForEach(Array(viewModel.nodes.enumerated()), id: \.element.id) { index, node in
                    if index < positions.count {
                        NodeView(
                            node: node,
                            stepNumber: index + 1,
                            onTap: {
                                viewModel.tapActiveNode()
                            }
                        )
                        .position(positions[index])
                    }
                }

                // MARK: - Layer 4: Level Title Badge (near active node)
                if positions.count > viewModel.currentNodeIndex {
                    levelBadge
                        .position(
                            x: positions[viewModel.currentNodeIndex].x > 200
                                ? positions[viewModel.currentNodeIndex].x - 90
                                : positions[viewModel.currentNodeIndex].x + 90,
                            y: positions[viewModel.currentNodeIndex].y - 10
                        )
                        .transition(.scale.combined(with: .opacity))
                }

                // MARK: - Layer 5: Chef Avatar (top)
                if positions.count > viewModel.avatarNodeIndex {
                    ChefAvatarView(isRunning: viewModel.isAvatarRunning)
                        .position(positions[viewModel.avatarNodeIndex])
                        .offset(y: -58)
                }

                // MARK: - Progress Indicator
                VStack {
                    HStack {
                        Spacer()
                        progressPill
                            .padding(.trailing, 16)
                            .padding(.top, 8)
                    }
                    Spacer()
                }
            }
            .onAppear {
                viewModel.nodePositions = positions
            }
        }
    }

    // MARK: - Level Badge
    private var levelBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.currentNode.locationIcon)
                .font(.system(size: 10, weight: .bold))
            Text(viewModel.currentLevelTitle)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
        }
        .foregroundColor(darkGreen)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.85))
                .shadow(color: greenColor.opacity(0.15), radius: 4, y: 2)
        )
        .overlay(
            Capsule()
                .stroke(greenColor.opacity(0.2), lineWidth: 0.5)
        )
    }

    // MARK: - Location Decoration
    private func locationDecoration(for node: CookingNode, at position: CGPoint, index: Int) -> some View {
        let isCompleted = node.state == .completed
        let isActive = node.state == .active
        let opacity: Double = isCompleted ? 0.18 : (isActive ? 0.14 : 0.08)

        // Offset decoration to the side opposite of the node's position
        let offsetX: CGFloat = position.x > 200 ? -55 : 55
        let offsetY: CGFloat = -35

        return ZStack {
            // Soft glow behind decoration
            Circle()
                .fill(node.environmentTint.accent)
                .frame(width: 50, height: 50)
                .blur(radius: 15)

            // Location icon
            Image(systemName: node.locationIcon)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(darkGreen.opacity(opacity * 4))

            // Small label
            Text(node.location)
                .font(.system(size: 7, weight: .semibold, design: .rounded))
                .foregroundColor(darkGreen.opacity(opacity * 3))
                .offset(y: 18)
        }
        .position(x: position.x + offsetX, y: position.y + offsetY)
    }

    // MARK: - Progress Pill
    private var progressPill: some View {
        let completed = viewModel.nodes.filter { $0.state == .completed }.count
        let total = viewModel.nodes.count

        return HStack(spacing: 6) {
            Text("\(completed + (viewModel.allCompleted ? 0 : 1)) of \(total)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(darkGreen)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.12))
                        .frame(height: 4)

                    Capsule()
                        .fill(greenColor)
                        .frame(width: geo.size.width * CGFloat(completed) / CGFloat(total), height: 4)
                }
            }
            .frame(width: 40, height: 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        )
        .overlay(
            Capsule()
                .stroke(greenColor.opacity(0.15), lineWidth: 0.5)
        )
    }
}

#Preview {
    MapView(viewModel: GameViewModel())
        .frame(height: 600)
        .background(Color(red: 0.941, green: 0.980, blue: 0.957))
}
