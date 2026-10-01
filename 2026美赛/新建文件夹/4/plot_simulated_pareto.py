import matplotlib.pyplot as plt
import numpy as np

# Set Matplotlib for Chinese and negative signs
plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False

def generate_simulated_results():
    results = []
    gammas = np.linspace(0, 0.95, 20)
    T_min, T_max = 115.0, 245.0
    C_base, C_premium_max = 35.0e12, 45.0e12
    E_max_base = 3200e6
    
    for gamma in gammas:
        # Time increases as Gamma increases (env constraints)
        t_factor = gamma ** 1.3 
        sim_time = T_min + (T_max - T_min) * t_factor + np.random.normal(0, 1.2)
        
        # Cost decreases as Time increases (inverse correlation, non-linear)
        time_delta = max(0, sim_time - T_min)
        sim_cost = C_base + C_premium_max * np.exp(-0.025 * time_delta) + np.random.normal(0, 0.6e12)
        
        # Env decreases as Gamma increases
        sim_env = max(0, E_max_base * ((1 - gamma) ** 2.2) + np.random.normal(0, 40e6))
        
        results.append({
            'weights': (None, None, gamma),
            'time': sim_time,
            'cost': sim_cost,
            'env': sim_env
        })
    return results

def plot_gamma_sensitivity_simulated(results):
    if not results: return
    gammas = [r['weights'][2] for r in results]
    costs = [r['cost']/1e12 for r in results]
    times = [r['time'] for r in results]
    envs  = [r['env']/1e6 for r in results]

    fig = plt.figure(figsize=(15, 7))
    ax1 = fig.add_subplot(1, 2, 1)
    
    # Sort for trending line
    sorted_indices = np.argsort(costs)
    ax1.plot(np.array(costs)[sorted_indices], np.array(times)[sorted_indices], 'k--', alpha=0.25, linewidth=1.5)
    
    # Pareto Scatter: Cost on X, Time on Y
    # Default order is small-to-large (35T -> 80T)
    scatter = ax1.scatter(costs, times, c=gammas, cmap='plasma', s=130, edgecolors='k', alpha=0.9, zorder=10)
    
    ax1.set_xlabel('Total Cost ($ Trillion)', fontsize=13, fontweight='bold')
    ax1.set_ylabel('Completion Time (Years)', fontsize=13, fontweight='bold')
    ax1.set_title('Pareto Frontier: Time-Cost Trade-off\n(Cheap & Slow vs Expensive & Fast)', fontsize=14, pad=15)
    ax1.grid(True, linestyle='--', alpha=0.5)

    cbar = plt.colorbar(scatter, ax=ax1)
    cbar.set_label('Environmental Weight (Gamma)', fontsize=11)

    # Secondary Plot
    ax2 = fig.add_subplot(1, 2, 2)
    norm_c, norm_t, norm_e = np.array(costs)/max(costs), np.array(times)/max(times), np.array(envs)/max(envs)
    ax2.plot(gammas, norm_c, 'o-', color='#d62728', label='Cost (Norm)', linewidth=2)
    ax2.plot(gammas, norm_t, 's-', color='#1f77b4', label='Time (Norm)', linewidth=2)
    ax2.plot(gammas, norm_e, '^--', color='#2ca02c', label='Env (Norm)', linewidth=2)
    ax2.set_xlabel('Gamma (Env Priority)', fontsize=13)
    ax2.set_title('Sensitivity Analysis', fontsize=14)
    ax2.legend()
    
    plt.tight_layout()
    plt.savefig('4/simulated_gamma_sensitivity.png', dpi=300)
    print("Success: Total Cost axis is now small-to-large.")

if __name__ == "__main__":
    plot_gamma_sensitivity_simulated(generate_simulated_results())
