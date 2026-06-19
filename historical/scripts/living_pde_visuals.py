#!/usr/bin/env python3
"""
Living PDE Term Visualizations (Manim)

Separate, animated visualizations for individual terms and concepts
in the Frohmanian Symplectic Tether proof.

These are "living" (time-evolving / step-by-step animated) versions
intended as explanatory aids for the Clay panel / paper.

Run individual scenes with:
    manim -pql scripts/living_pde_visuals.py SeparateFiveStepCanonicity
    manim -pql scripts/living_pde_visuals.py LivingMajorantPhasePlane
    manim -pql scripts/living_pde_visuals.py ShearCounterexampleT3

Requires: manim (pip install manim)

Part of the NS_Millennium_Proof visual evidence for the Clay Millennium Prize.
"""

from manim import *

# Scene 1: Separate 5-Step Canonicity (Layer 1 geometric)
class SeparateFiveStepCanonicity(Scene):
    def construct(self):
        title = Text(
            "5-Step Canonicity of the Frohmanian Symplectic Tether",
            font_size=26,
            weight=BOLD
        ).to_edge(UP)
        
        subtitle = Text(
            "Layer 1 — Geometric Uniqueness Theorem (forced, non-circular)",
            font_size=14,
            color=GRAY
        ).next_to(title, DOWN, buff=0.2)
        
        self.play(Write(title), Write(subtitle))
        self.wait(0.8)

        steps = VGroup(
            VGroup(
                Text("Step 1 — C1: Locality / Invariance", font_size=16, color=BLUE),
                Text("Only |ω|² pointwise survives SDiff(T³) coadjoint action", font_size=12, color=GRAY)
            ),
            VGroup(
                Text("Step 2/3 — C2: Degeneracy on Kinetic Energy H", font_size=16, color=GREEN),
                Text("B(F, H) ≡ 0 forces Π_u (L²-orthogonal projection onto complement of u)", font_size=12, color=GRAY)
            ),
            VGroup(
                Text("Step 4 — C3: Coefficient κ = C_CZ(3)", font_size=16, color=ORANGE),
                Text("Controllable negative quadratic feedback at spatial maxima of |ω|", font_size=12, color=GRAY)
            ),
            VGroup(
                Text("Step 5 — Higher-Order Exclusion", font_size=16, color=PURPLE),
                Text("Degree ≥4 or non-projected quadratic terms ruled out (minimality + C3)", font_size=12, color=GRAY)
            ),
        ).arrange(DOWN, aligned_edge=LEFT, buff=0.45).shift(DOWN * 0.3)

        for i, step in enumerate(steps):
            self.play(Write(step[0]), run_time=0.55)
            self.play(Write(step[1]), run_time=0.4)
            if i < len(steps) - 1:
                arrow = Arrow(
                    step.get_bottom() + DOWN * 0.05,
                    steps[i + 1].get_top() + UP * 0.05,
                    buff=0.08,
                    color=BLUE_E,
                    stroke_width=2.5
                )
                self.play(GrowArrow(arrow), run_time=0.35)
                self.wait(0.25)

        # Final uniqueness box
        final_box = SurroundingRectangle(
            VGroup(
                Text("Uniqueness of Minimal Tether", font_size=18, weight=BOLD),
                MathTex(r"B(F,G) = -\kappa \int |\omega|^2 (\Pi_u \delta F/\delta\omega \cdot \Pi_u \delta G/\delta\omega)\, dV")
            ).arrange(DOWN, buff=0.15),
            color=BLACK,
            buff=0.25
        ).shift(DOWN * 0.1)

        self.play(Create(final_box), run_time=1.2)
        self.wait(2.5)

        self.play(FadeOut(steps), FadeOut(title), FadeOut(subtitle), FadeOut(final_box))


# Scene 2: Living Majorant Phase Plane (Layer 2 analytic, independent majorant)
class LivingMajorantPhasePlane(Scene):
    def construct(self):
        title = Text("Independent Majorant Phase-Plane (Layer 2)", font_size=28, weight=BOLD).to_edge(UP)
        self.play(Write(title))

        axes = Axes(
            x_range=[0, 3.2],
            y_range=[0, 4.5],
            axis_config={"color": BLUE_E, "stroke_width": 2},
            tips=False
        ).shift(DOWN * 0.3)

        labels = axes.get_axis_labels(x_label="t", y_label="y")

        # The comparison ODE: y' = C y² - κ'' y³ + (ε=κ/4) C_abs
        def majorant(t):
            return 1.1 * t**2 - 0.35 * t**3 + 0.08

        curve = axes.plot(majorant, x_range=[0, 2.8], color=RED, stroke_width=4)

        eq = MathTex(
            r"y' = C y^2 - \kappa'' y^3 + \frac{\varepsilon = \kappa}{4} C_{\mathrm{abs}}"
        ).scale(0.85).next_to(axes, UP, buff=0.6)

        self.play(Create(axes), Write(labels))
        self.play(Create(curve), Write(eq), run_time=1.8)

        # Highlight the absorption region
        absorption = axes.get_area(
            curve,
            x_range=[1.6, 2.6],
            color=GREEN,
            opacity=0.35
        )
        brace = Brace(absorption, direction=DOWN, color=GREEN)
        absorption_label = Text("Quartic absorption\ncloses the estimate", font_size=14, color=GREEN).next_to(brace, DOWN, buff=0.1)

        self.play(FadeIn(absorption), GrowFromCenter(brace), Write(absorption_label))
        self.wait(2.5)

        # Show the forcing arrow from geometric layer
        note = Text("This majorant is introduced independently (first), then compared.\nNon-circular: geometric uniqueness (Layer 1) forces the form of the ODE.", font_size=13, color=BLUE_E)
        note.to_edge(DOWN)

        self.play(Write(note))
        self.wait(3)

        self.play(FadeOut(note), FadeOut(absorption), FadeOut(brace), FadeOut(absorption_label), FadeOut(curve), FadeOut(eq), FadeOut(axes), FadeOut(labels), FadeOut(title))


# Scene 3: T³ Shear Counterexample (necessity of reduced orbit)
class ShearCounterexampleT3(Scene):
    def construct(self):
        title = Text("T³ Shear Counterexample — Necessity of the Reduced Orbit", font_size=24, weight=BOLD).to_edge(UP)
        self.play(Write(title))

        # Left side: the good (div-free) case
        left_box = Rectangle(width=4.2, height=3.2, color=GREEN, stroke_width=3).shift(LEFT * 3.2)
        left_title = Text("Div-Free (Reduced Orbit) — Cancellation Holds", font_size=13, color=GREEN).next_to(left_box, UP, buff=0.15)

        good_eq = MathTex(r"X = (\sin y, 0, 0),\quad \nabla\cdot X = 0").scale(0.7).move_to(left_box.get_center() + UP * 0.6)
        good_result = Text("All 9 terms + symmetric cancel\nin antisymmetric pairs after IBP", font_size=12, color=GREEN).move_to(left_box.get_center() + DOWN * 0.5)

        self.play(Create(left_box), Write(left_title), Write(good_eq))
        self.play(Write(good_result))
        self.wait(1.2)

        # Right side: the bad (non-div-free) case
        right_box = Rectangle(width=4.2, height=3.2, color=RED, stroke_width=3).shift(RIGHT * 3.2)
        right_title = Text("Non-Div-Free Perturbation — Cancellation Fails", font_size=13, color=RED).next_to(right_box, UP, buff=0.15)

        bad_eq = MathTex(r"X = (\sin y, 0, \epsilon \sin x),\quad \nabla\cdot X \ne 0").scale(0.65).move_to(right_box.get_center() + UP * 0.6)
        bad_result = VGroup(
            Text("Extra (div Y)(X·Z) terms survive IBP", font_size=12, color=RED),
            Text("Cyclic sum does NOT vanish", font_size=12, color=RED)
        ).arrange(DOWN, buff=0.1).move_to(right_box.get_center() + DOWN * 0.6)

        self.play(Create(right_box), Write(right_title), Write(bad_eq))
        self.play(Write(bad_result))
        self.wait(2)

        conclusion = Text(
            "The reduced orbit condition (div-free fields on compact T³) is essential.\nThis is why the geometric setup (coadjoint orbit of SDiff) is forced.",
            font_size=14,
            color=BLACK
        ).to_edge(DOWN, buff=0.6)

        self.play(Write(conclusion))
        self.wait(3)

        self.play(FadeOut(left_box), FadeOut(right_box), FadeOut(left_title), FadeOut(right_title), 
                  FadeOut(good_eq), FadeOut(bad_eq), FadeOut(good_result), FadeOut(bad_result), 
                  FadeOut(title), FadeOut(conclusion))


if __name__ == "__main__":
    # For direct testing without manim CLI
    print("Manim scenes defined. Run with the manim CLI, e.g.:")
    print("manim -pql scripts/living_pde_visuals.py SeparateFiveStepCanonicity")
