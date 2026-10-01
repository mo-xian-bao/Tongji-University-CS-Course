import tkinter as tk
from tkinter import ttk, filedialog, messagebox
from PIL import Image, ImageTk
import fitz  # PyMuPDF
from PyPDF2 import PdfReader, PdfWriter
import os
import math


class PDFSplitter:
    def __init__(self, root):
        self.root = root
        self.root.title("PDF 拆分工具")
        self.root.geometry("900x750")
        
        self.pdf_path = None
        self.pdf_doc = None
        self.total_pages = 0
        self.page_images = []
        self.page_labels = []
        
        self.setup_ui()

    def setup_ui(self):
        # 顶部控制区
        control_frame = ttk.Frame(self.root, padding=10)
        control_frame.pack(fill=tk.X)

        ttk.Button(control_frame, text="选择 PDF 文件", command=self.open_pdf).pack(side=tk.LEFT)
        
        self.file_label = ttk.Label(control_frame, text="未选择文件")
        self.file_label.pack(side=tk.LEFT, padx=20)

        # 模式选择
        mode_frame = ttk.LabelFrame(self.root, text="拆分模式", padding=10)
        mode_frame.pack(fill=tk.X, padx=10, pady=5)

        self.mode_var = tk.StringVar(value="range")
        ttk.Radiobutton(mode_frame, text="按页码范围", variable=self.mode_var, 
                        value="range", command=self.on_mode_change).pack(side=tk.LEFT)
        ttk.Radiobutton(mode_frame, text="按固定页数", variable=self.mode_var,
                        value="batch", command=self.on_mode_change).pack(side=tk.LEFT, padx=20)

        # 页码范围选择
        self.range_frame = ttk.Frame(self.root, padding=10)
        self.range_frame.pack(fill=tk.X)

        ttk.Label(self.range_frame, text="起始页:").pack(side=tk.LEFT)
        self.start_var = tk.IntVar(value=1)
        self.start_spin = ttk.Spinbox(self.range_frame, from_=1, to=1, width=8, 
                                       textvariable=self.start_var, command=self.update_selection)
        self.start_spin.pack(side=tk.LEFT, padx=5)

        ttk.Label(self.range_frame, text="结束页:").pack(side=tk.LEFT, padx=(20, 0))
        self.end_var = tk.IntVar(value=1)
        self.end_spin = ttk.Spinbox(self.range_frame, from_=1, to=1, width=8,
                                     textvariable=self.end_var, command=self.update_selection)
        self.end_spin.pack(side=tk.LEFT, padx=5)

        ttk.Button(self.range_frame, text="拆分并保存", command=self.split_pdf).pack(side=tk.RIGHT)

        # 按页数拆分选择
        self.batch_frame = ttk.Frame(self.root, padding=10)

        ttk.Label(self.batch_frame, text="每份页数:").pack(side=tk.LEFT)
        self.pages_per_file_var = tk.IntVar(value=8)
        self.pages_spin = ttk.Spinbox(self.batch_frame, from_=1, to=100, width=8,
                                       textvariable=self.pages_per_file_var)
        self.pages_spin.pack(side=tk.LEFT, padx=5)

        self.batch_info_label = ttk.Label(self.batch_frame, text="")
        self.batch_info_label.pack(side=tk.LEFT, padx=20)

        ttk.Button(self.batch_frame, text="批量拆分", command=self.batch_split_pdf).pack(side=tk.RIGHT)

        # 预览区域（带滚动条）
        preview_container = ttk.Frame(self.root)
        preview_container.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        self.canvas = tk.Canvas(preview_container)
        scrollbar = ttk.Scrollbar(preview_container, orient=tk.VERTICAL, command=self.canvas.yview)
        self.preview_frame = ttk.Frame(self.canvas)

        self.preview_frame.bind("<Configure>", 
                                 lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))
        self.canvas.create_window((0, 0), window=self.preview_frame, anchor="nw")
        self.canvas.configure(yscrollcommand=scrollbar.set)

        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        # 鼠标滚轮支持
        self.canvas.bind_all("<MouseWheel>", lambda e: self.canvas.yview_scroll(int(-1*(e.delta/120)), "units"))

    def on_mode_change(self):
        if self.mode_var.get() == "range":
            self.batch_frame.pack_forget()
            self.range_frame.pack(fill=tk.X, before=self.canvas.master)
        else:
            self.range_frame.pack_forget()
            self.batch_frame.pack(fill=tk.X, before=self.canvas.master)
            self.update_batch_info()

    def update_batch_info(self):
        if self.total_pages > 0:
            pages_per = self.pages_per_file_var.get()
            num_files = math.ceil(self.total_pages / pages_per)
            self.batch_info_label.config(text=f"将生成 {num_files} 个文件")

    def open_pdf(self):
        path = filedialog.askopenfilename(filetypes=[("PDF Files", "*.pdf")])
        if path:
            self.pdf_path = path
            self.pdf_doc = fitz.open(path)
            self.total_pages = len(self.pdf_doc)
            
            self.file_label.config(text=f"{os.path.basename(path)} | 共 {self.total_pages} 页")
            
            self.start_spin.config(to=self.total_pages)
            self.end_spin.config(to=self.total_pages)
            self.start_var.set(1)
            self.end_var.set(self.total_pages)
            
            self.update_batch_info()
            self.render_preview()

    def render_preview(self):
        for widget in self.preview_frame.winfo_children():
            widget.destroy()
        self.page_images.clear()
        self.page_labels.clear()

        cols = 4
        for i in range(self.total_pages):
            page = self.pdf_doc[i]
            pix = page.get_pixmap(matrix=fitz.Matrix(0.25, 0.25))
            
            img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
            photo = ImageTk.PhotoImage(img)
            self.page_images.append(photo)

            frame = ttk.Frame(self.preview_frame, padding=5)
            frame.grid(row=i // cols, column=i % cols, padx=5, pady=5)

            label = ttk.Label(frame, image=photo)
            label.pack()

            text = ttk.Label(frame, text=f"第 {i + 1} 页")
            text.pack()

            self.page_labels.append((frame, i + 1))

        self.update_selection()

    def update_selection(self):
        try:
            start = self.start_var.get()
            end = self.end_var.get()
        except:
            return

        for frame, page_num in self.page_labels:
            if start <= page_num <= end:
                frame.configure(style="Selected.TFrame")
            else:
                frame.configure(style="TFrame")

    def split_pdf(self):
        if not self.pdf_path:
            messagebox.showwarning("提示", "请先选择 PDF 文件")
            return

        start = self.start_var.get()
        end = self.end_var.get()

        if start > end:
            messagebox.showerror("错误", "起始页不能大于结束页")
            return

        save_path = filedialog.asksaveasfilename(
            defaultextension=".pdf",
            initialfile=f"split_{start}-{end}.pdf",
            filetypes=[("PDF Files", "*.pdf")]
        )

        if save_path:
            pdf_reader = PdfReader(self.pdf_path)
            pdf_writer = PdfWriter()

            for page_num in range(start - 1, end):
                pdf_writer.add_page(pdf_reader.pages[page_num])

            with open(save_path, "wb") as f:
                pdf_writer.write(f)

            messagebox.showinfo("成功", f"已保存到:\n{save_path}")

    def batch_split_pdf(self):
        if not self.pdf_path:
            messagebox.showwarning("提示", "请先选择 PDF 文件")
            return

        pages_per_file = self.pages_per_file_var.get()
        if pages_per_file < 1:
            messagebox.showerror("错误", "每份页数必须大于0")
            return

        # 选择保存目录
        save_dir = filedialog.askdirectory(title="选择保存目录")
        if not save_dir:
            return

        pdf_reader = PdfReader(self.pdf_path)
        base_name = os.path.splitext(os.path.basename(self.pdf_path))[0]
        
        num_files = math.ceil(self.total_pages / pages_per_file)
        
        for i in range(num_files):
            start_page = i * pages_per_file
            end_page = min((i + 1) * pages_per_file, self.total_pages)
            
            pdf_writer = PdfWriter()
            for page_num in range(start_page, end_page):
                pdf_writer.add_page(pdf_reader.pages[page_num])
            
            output_path = os.path.join(save_dir, f"{base_name}_第{start_page+1}-{end_page}页.pdf")
            with open(output_path, "wb") as f:
                pdf_writer.write(f)

        messagebox.showinfo("成功", f"已拆分为 {num_files} 个文件\n保存到: {save_dir}")


if __name__ == "__main__":
    root = tk.Tk()
    app = PDFSplitter(root)
    root.mainloop()
