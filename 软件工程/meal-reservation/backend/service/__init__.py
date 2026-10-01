"""Service package helpers and shared paths."""
import os

SERVICE_DIR = os.path.dirname(__file__)
BACKEND_DIR = os.path.abspath(os.path.join(SERVICE_DIR, ".."))
STATIC_DIR = os.path.join(BACKEND_DIR, "static")

__all__ = ["SERVICE_DIR", "BACKEND_DIR", "STATIC_DIR"]
