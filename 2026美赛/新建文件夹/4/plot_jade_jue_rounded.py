import matplotlib.pyplot as plt
import numpy as np
import matplotlib.lines as mlines
import matplotlib

# Ensure using a backend that doesn't need a display
matplotlib.use('Agg')

# -----------------------------------------------------------------------------
# Data Configuration
# -----------------------------------------------------------------------------
labels = [
    'ATM',
    'DEBRIS',
    'RES',
    'LOCAL'
]
values = [4200, 1800, 3000, 1000]
values2 = [4000, 600, 2200, 400]

colors = ["#06751C", "#43c81b", "#86f28f", "#70e6b7"]

# -----------------------------------------------------------------------------
# Plotting
# -----------------------------------------------------------------------------
# Canvas Size: Reduced Width-Height Ratio
# Using a more square-like layout (width 8, height 6)
fig, ax = plt.subplots(figsize=(8, 6), subplot_kw={'projection': 'polar'})

# Configuration
ax.set_theta_zero_location('N')
ax.set_theta_direction(-1) # Clockwise
ax.set_axis_off()

# Layout Parameters
radii = [4.4, 3.6, 2.8, 2.0]
ax.set_ylim(0, 5.5)
line_width = 20
max_val_reference = 4000 / 0.8

# Fixed X-offset for Vertical Alignment of Labels
# We want labels to be at a constant X position to the left of the vertical axis.
# In our Polar (N-zero, CW) system, where theta=0 is North (Y axis):
# The visual coordinate transformation is roughly:
# X_visual = Radius * sin(Theta)
# Y_visual = Radius * cos(Theta)
# We want X_visual = constant_offset (negative for left)
# So sin(Theta) = constant_offset / Radius
# Theta = arcsin(constant_offset / Radius)

target_x_offset = -0.6  # constant negative X offset

for val,val2, rad, col in zip(values, values2, radii, colors):
    # Draw Arc
    angle_span = (val / max_val_reference) * 2 * np.pi
    theta = np.linspace(0, angle_span, 200)
    r = np.full_like(theta, rad)
    ax.plot(theta, r, color=col, linewidth=line_width, solid_capstyle='round')
    
    # Calculate Label Position for Vertical Alignment
    # We solve for theta given r and target x
    # target_x_offset must be within [-r, r]
    sin_theta = target_x_offset / rad
    label_theta = np.arcsin(sin_theta)
    
    # Draw Label
    # ha='right' aligns the text end to the calculated point
    ax.text(label_theta, rad, str(val2), 
            ha='right', va='center', 
            fontsize=12, fontweight='bold', color=col)

# -----------------------------------------------------------------------------
# Legend
# -----------------------------------------------------------------------------
legend_handles = []
for c, l in zip(colors, labels):
    h = mlines.Line2D([], [], color='white', marker='o', 
                      markerfacecolor=c, markersize=20, label=l)
    legend_handles.append(h)

# Positioning the legend
plt.legend(handles=legend_handles, 
           bbox_to_anchor=(1.0, 1.0), 
           loc='upper left', 
           frameon=False, 
           fontsize=16, 
           labelspacing=1.0,
           handletextpad=0.5)

plt.tight_layout()

# Save output
output_file = 'd:/desktop/新建文件夹/4/jade_jue_rounded_aligned.png'
plt.savefig(output_file, dpi=300, bbox_inches='tight', facecolor='white')
print(f"Chart saved to {output_file}")
