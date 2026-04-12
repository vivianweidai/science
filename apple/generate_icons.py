"""Generate app icon: pastel orange triangle with rounded corners,
thick white border, pastel sky blue background. Sharp edges, no blur."""

from PIL import Image, ImageDraw
import math, os

SIZE = 1024
OUT = os.path.dirname(os.path.abspath(__file__))


def gradient_bg(img, top, bot):
    draw = ImageDraw.Draw(img)
    for y in range(SIZE):
        t = y / SIZE
        c = tuple(int(top[i] + (bot[i] - top[i]) * t) for i in range(3))
        draw.line([(0, y), (SIZE, y)], fill=c)


def rounded_triangle_path(cx, top_y, side, corner_radius):
    """Compute a rounded equilateral triangle as a list of (x,y) points
    by placing arcs at each vertex. Returns a polygon approximation."""
    tri_h = side * math.sqrt(3) / 2
    # Three vertices of the sharp triangle
    A = (cx, top_y)                          # top
    B = (cx + side / 2, top_y + tri_h)      # bottom right
    C = (cx - side / 2, top_y + tri_h)      # bottom left

    verts = [A, B, C]
    points = []

    for i in range(3):
        p0 = verts[(i - 1) % 3]
        p1 = verts[i]
        p2 = verts[(i + 1) % 3]

        # Vectors from vertex to neighbors
        dx1, dy1 = p0[0] - p1[0], p0[1] - p1[1]
        dx2, dy2 = p2[0] - p1[0], p2[1] - p1[1]
        len1 = math.hypot(dx1, dy1)
        len2 = math.hypot(dx2, dy2)
        dx1, dy1 = dx1 / len1, dy1 / len1
        dx2, dy2 = dx2 / len2, dy2 / len2

        # Half angle at vertex
        dot = dx1 * dx2 + dy1 * dy2
        half_angle = math.acos(max(-1, min(1, dot))) / 2

        # Distance from vertex to where the arc starts
        d = corner_radius / math.tan(half_angle)

        # Start and end points of the arc on each edge
        start = (p1[0] + dx1 * d, p1[1] + dy1 * d)
        end = (p1[0] + dx2 * d, p1[1] + dy2 * d)

        # Center of the arc
        # Bisector direction (pointing inward)
        bx, by = dx1 + dx2, dy1 + dy2
        blen = math.hypot(bx, by)
        bx, by = bx / blen, by / blen
        center_dist = corner_radius / math.sin(half_angle)
        center = (p1[0] + bx * center_dist, p1[1] + by * center_dist)

        # Generate arc points
        angle_start = math.atan2(start[1] - center[1], start[0] - center[0])
        angle_end = math.atan2(end[1] - center[1], end[0] - center[0])

        # Ensure we go the short way around
        diff = angle_end - angle_start
        if diff > math.pi:
            diff -= 2 * math.pi
        elif diff < -math.pi:
            diff += 2 * math.pi

        n_arc = 32
        for j in range(n_arc + 1):
            t = j / n_arc
            angle = angle_start + diff * t
            px = center[0] + corner_radius * math.cos(angle)
            py = center[1] + corner_radius * math.sin(angle)
            points.append((px, py))

    return points


def fill_with_gradient(img, points, top_color, bot_color):
    """Fill polygon with vertical gradient using scanline."""
    mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(mask).polygon(points, fill=255)
    grad = Image.new("RGB", (SIZE, SIZE))
    gd = ImageDraw.Draw(grad)
    for y in range(SIZE):
        t = y / SIZE
        c = tuple(int(top_color[i] + (bot_color[i] - top_color[i]) * t) for i in range(3))
        gd.line([(0, y), (SIZE, y)], fill=c)
    img.paste(grad, mask=mask)


def make_icon(name, border_thickness, corner_radius):
    bg_top = (120, 190, 250)
    bg_bot = (190, 220, 255)
    fill_top = (255, 165, 60)
    fill_bot = (255, 140, 30)

    img = Image.new("RGB", (SIZE, SIZE))
    gradient_bg(img, bg_top, bg_bot)

    # Outer triangle dimensions
    outer_padding = 70
    outer_side = SIZE - 2 * outer_padding
    outer_top_y = (SIZE - outer_side * math.sqrt(3) / 2) / 2 - 20
    outer_pts = rounded_triangle_path(SIZE // 2, outer_top_y, outer_side, corner_radius)

    # Inner triangle — inset uniformly by border_thickness
    inner_side = outer_side - border_thickness * 2 / math.cos(math.radians(30))
    inner_h = inner_side * math.sqrt(3) / 2
    # Center the inner triangle at the same centroid
    outer_h = outer_side * math.sqrt(3) / 2
    outer_centroid_y = outer_top_y + outer_h * 2 / 3
    inner_top_y = outer_centroid_y - inner_h * 2 / 3
    inner_corner = max(corner_radius - border_thickness * 0.6, 5)
    inner_pts = rounded_triangle_path(SIZE // 2, inner_top_y, inner_side, inner_corner)

    # Draw white border shape
    draw = ImageDraw.Draw(img)
    draw.polygon(outer_pts, fill=(255, 255, 255))

    # Fill inner with pastel orange gradient
    fill_with_gradient(img, inner_pts, fill_top, fill_bot)

    img.save(os.path.join(OUT, name))


if __name__ == "__main__":
    make_icon("icon_option_1.png", 75, 15)
    print("Generated icon")
