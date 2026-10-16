
//
//  MatchMarkers.swift
//  CodeBreaker
//

import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    // MARK: Data In
    let matches: [Match]

    // MARK: - Body
    var body: some View {

        HStack(alignment: .top, spacing: 7) {

            VStack(spacing:4) {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }

            VStack(spacing: 4) {
                matchMarker(peg: 2)

                if matches.count > 3 {
                    matchMarker(peg: 3)
                }
            }

            VStack(spacing: 4) {

                if matches.count > 4 {
                    matchMarker(peg: 4)
                }

                if matches.count > 5 {
                    matchMarker(peg: 5)
                }
            }
        }
        //.fixedSize()
    }

    func matchMarker(peg: Int) -> some View {

        let exactCount = matches.count { $0 == .exact }

        let foundCount = matches.count {
            $0 != .nomatch
        }
            
        
        
        return Circle()
            .fill(
                exactCount > peg
                    ? Color.primary
                    : Color.clear
            )
            .strokeBorder(
                foundCount > peg
                    ? Color.primary
                    : Color.clear,
                lineWidth: 2
            )
            .aspectRatio(1, contentMode: .fit)
            
            .frame(height: 15)
            
    }
}

struct MatchMarkersPreview: View {

    var matches: [Match]

    var body: some View {

        HStack(spacing: 8) {

            ForEach(0..<matches.count, id: \.self) { _ in
                Circle()
                    .fill(Color.primary)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 40)
            }

            MatchMarkers(matches: matches)
        }
        .fixedSize()
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 36) {

        MatchMarkersPreview(
            matches: [.exact, .inexact, .inexact]
        )

        MatchMarkersPreview(
            matches: [.exact, .nomatch, .nomatch]
        )

        MatchMarkersPreview(
            matches: [.exact, .exact, .inexact, .inexact]
        )

        MatchMarkersPreview(
            matches: [.exact, .exact, .inexact, .nomatch]
        )

        MatchMarkersPreview(
            matches: [.exact, .inexact, .nomatch, .nomatch]
        )

        MatchMarkersPreview(
            matches: [
                .exact, .exact, .exact,
                .inexact, .nomatch, .nomatch
            ]
        )

        MatchMarkersPreview(
            matches: [
                .exact, .exact, .exact,
                .inexact, .inexact, .inexact
            ]
        )

        MatchMarkersPreview(
            matches: [
                .exact, .exact,
                .inexact, .inexact, .inexact
            ]
        )

        MatchMarkersPreview(
            matches: [
                .exact,
                .inexact, .inexact,
                .nomatch, .nomatch
            ]
        )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
}
